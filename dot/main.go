package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
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
		_          = ctx
		moduleDirs = os.Args[1:]
	)

	for _, moduleDir := range moduleDirs {
		if exists, err := fileExists(moduleDir); err != nil {
			return err
		} else if !exists {
			return errors.New("module dir does not exist")
		}

		srcDir := filepath.Join(moduleDir, ".config.tmpl")
		if exists, err := fileExists(srcDir); err != nil {
			return err
		} else if !exists {
			continue
		}

		srcDirEntries, err := os.ReadDir(srcDir)
		if err != nil {
			return err
		}

		for _, srcDirEntry := range srcDirEntries {
			dstDirEntryString := filepath.Join(homeDir(), ".config.tmpl", srcDirEntry.Name())
			srcDirEntryString := filepath.Join(srcDir, srcDirEntry.Name())
			_, _ = dstDirEntryString, srcDirEntryString
		}
	}

	return nil
}

func homeDir() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(fmt.Errorf("home dir: %w", err))
	}

	return homeDir
}

func fileExists(file string) (bool, error) {
	_, err := os.Stat(file)

	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}

	if err != nil {
		return false, fmt.Errorf("file exists: %w", err)
	}

	return true, nil
}

func isDir(file string) (bool, error) {
	fileInfo, err := os.Stat(file)
	if err != nil {
		return false, fmt.Errorf("is dir: %w", err)
	}

	return fileInfo.IsDir(), nil
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
