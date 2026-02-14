package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"os"
)

var errModuleNotFound = errors.New("module not found")

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
		service    = newService()
	)

	for _, moduleDir := range moduleDirs {
		if err := service.doModule(ctx, moduleDir); err != nil {
			slog.ErrorContext(ctx, err.Error(), "module_dir", moduleDir)
		}
	}

	return nil
}

type service struct{}

func newService() *service {
	return &service{}
}

func (s *service) doModule(ctx context.Context, moduleDir string) error {
	if err := s.checkModuleExists(moduleDir); err != nil {
		return fmt.Errorf("do module: %w", err)
	}

	return nil
}

func (s *service) checkModuleExists(moduleDir string) error {
	_, err := os.Stat(moduleDir)

	if errors.Is(err, os.ErrNotExist) {
		return fmt.Errorf("check module exists: %w", errModuleNotFound)
	}

	if err != nil {
		return fmt.Errorf("check module exists: %w", err)
	}

	return nil
}
