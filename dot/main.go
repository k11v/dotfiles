package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
)

var (
	errDestinationExist = errors.New("destination already exists")
	errSourceNotFound   = errors.New("source not found")
	errSourceNotValid   = errors.New("source not valid")
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	os.Exit(0)
}

func run() error {
	var (
		ctx        = context.Background()
		moduleDirs = os.Args[1:]
		logger     = slog.Default()
		store      = MustNewStore(logger)
		service    = NewService(logger, store)
	)

	for _, moduleDir := range moduleDirs {
		if err := service.doModule(ctx, moduleDir); err != nil {
			slog.ErrorContext(ctx, err.Error(), "module_dir", moduleDir)
		}
	}

	return nil
}

type Service struct {
	logger *slog.Logger
	store  *Store
}

func NewService(logger *slog.Logger, store *Store) *Service {
	return &Service{
		logger: logger,
		store:  store,
	}
}

func (s *Service) doModule(ctx context.Context, moduleDir string) error {
	if !s.fileExists(moduleDir) {
		return fmt.Errorf("do module: %w", errSourceNotFound)
	}

	dos := []func(context.Context, string) error{
		s.doModuleConfigTemplate,
	}

	for _, do := range dos {
		if err := do(ctx, moduleDir); err != nil {
			s.logger.ErrorContext(ctx, err.Error(), "module_dir", moduleDir)
		}
	}

	return nil
}

func (s *Service) doModuleConfigTemplate(ctx context.Context, moduleDir string) error {
	srcDir := filepath.Join(moduleDir, ".config")
	if !s.fileExists(srcDir) {
		return fmt.Errorf("do module config template: %w", errSourceNotFound)
	}

	srcDirEntries, err := os.ReadDir(srcDir)
	if err != nil {
		return fmt.Errorf("do module config template: %w", err)
	}

	for _, srcDirEntry := range srcDirEntries {
		if err := s.doModuleConfigTemplateEntry(filepath.Join(srcDir, srcDirEntry.Name())); err != nil {
			return fmt.Errorf("do module config template: %w", err)
		}
	}

	return nil
}

func (s *Service) doModuleConfigTemplateEntry(srcDirEntry string) error {
	if !s.fileExists(srcDirEntry) {
		return fmt.Errorf("do module config template entry: %w", errSourceNotFound)
	}

	if !strings.HasSuffix(srcDirEntry, ".tmpl") {
		return fmt.Errorf("do module config template entry: %w", errSourceNotValid)
	}

	dstDirEntry := filepath.Join(s.homeDir(), ".config", strings.TrimSuffix(srcDirEntry, ".tmpl"))

	if err := s.doTemplate(dstDirEntry, srcDirEntry); err != nil {
		return fmt.Errorf("do module config template: %w", err)
	}

	return nil
}

func (s *Service) doTemplate(dst, src string) error {
	return nil
}

func (s *Service) homeDir() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(fmt.Errorf("home dir: %w", err))
	}

	return homeDir
}

func (s *Service) fileExists(file string) bool {
	_, err := os.Stat(file)

	if errors.Is(err, os.ErrNotExist) {
		return false
	}

	if err != nil {
		panic(fmt.Errorf("file exists: %w", err))
	}

	return true
}

func (s *Service) isDir(file string) bool {
	fileInfo, err := os.Stat(file)
	if err != nil {
		panic(fmt.Errorf("is dir: %w", err))
	}

	return fileInfo.IsDir()
}

type TemplateInfo struct {
	Dst       string `json:"dst"`
	Src       string `json:"src"`
	DstSHA256 string `json:"dst_sha256"`
}

type Store struct {
	logger        *slog.Logger
	templateInfos []TemplateInfo
}

func MustNewStore(logger *slog.Logger) *Store {
	store, err := NewStore(logger)
	if err != nil {
		panic(err)
	}

	return store
}

func NewStore(logger *slog.Logger) (*Store, error) {
	store := &Store{
		logger:        logger,
		templateInfos: nil, // computed
	}

	f, err := os.Open(store.templateInfosFile())
	if errors.Is(err, os.ErrNotExist) {
		return store, nil
	} else if err != nil {
		return nil, fmt.Errorf("new store: %w", err)
	}
	defer f.Close()

	if err = json.NewDecoder(f).Decode(&store.templateInfos); err != nil {
		return nil, fmt.Errorf("new store: %w", err)
	}

	return store, nil
}

func (s *Store) Close() error {
	f, err := os.CreateTemp("", "")
	if err != nil {
		return fmt.Errorf("store close: %w", err)
	}
	defer f.Close()

	enc := json.NewEncoder(f)
	enc.SetIndent("", "\t")
	if err = json.NewEncoder(f).Encode(s.templateInfos); err != nil {
		return fmt.Errorf("store close: %w", err)
	}

	if err = f.Close(); err != nil {
		return fmt.Errorf("store close: %w", err)
	}

	templateInfosDir := filepath.Dir(s.templateInfosFile())
	if err = os.MkdirAll(templateInfosDir, 0x777); err != nil {
		return fmt.Errorf("store close: %w", err)
	}

	if err = os.Rename(f.Name(), s.templateInfosFile()); err != nil {
		return fmt.Errorf("store close: %w", err)
	}

	s.templateInfos = nil

	return nil
}

func (s *Store) TemplateInfo(dst string) *TemplateInfo {
	var templateInfo *TemplateInfo

	for _, ti := range s.templateInfos {
		if ti.Dst == dst {
			templateInfo = &ti
		}
	}

	return templateInfo
}

func (s *Store) SetTemplateInfo(dst string, info *TemplateInfo) {
	index := -1

	for i := range len(s.templateInfos) {
		if s.templateInfos[i].Dst == dst {
			index = i
		}
	}

	switch {
	case info == nil && index == -1:
		// No-op.
	case info == nil && index != -1:
		s.templateInfos = append(s.templateInfos[:index], s.templateInfos[index+1:]...)
	case info != nil && index == -1:
		s.templateInfos = append(s.templateInfos, *info)
	case info != nil && index != -1:
		s.templateInfos[index] = *info
	default:
		panic("unreachable")
	}
}

func (s *Store) templateInfosFile() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(fmt.Errorf("data dir: %w", err))
	}

	dataDir := filepath.Join(homeDir, ".local", "share", "dot")

	return filepath.Join(dataDir, "template_infos.json")
}
