package main

import (
	"errors"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"runtime"
)

func main() {
	os.Exit(run())
}

func run() int {
	dotfilesDir := dotfilesDir()
	if dotfilesDir == "" {
		slog.Error("empty dotfiles dir")
		return 1
	}

	dotfilesEntries, err := os.ReadDir(dotfilesDir)
	if err != nil {
		slog.Error("reading dotfiles dir failed", "error", err)
		return 1
	}

	for _, dotfilesEntry := range dotfilesEntries {
		if dotfilesEntry.IsDir() {
			detectActions(filepath.Join(dotfilesDir, dotfilesEntry.Name()))
		}
	}


	return 0
}

type Action struct {
	ConfigAction *ConfigAction
	BinAction    *BinAction
}

func detectActions(modDir string) ([]Action, error) {
	var (
		actions []Action
		err     error
	)

	actions2, err2 := detectConfigActions(modDir)
	actions = append(actions, actions2...)
	err = errors.Join(err, err2)

	actions2, err2 = detectBinActions(modDir)
	actions = append(actions, actions2...)
	err = errors.Join(err, err2)

	return actions, err
}

type ConfigAction struct {
	Name       string
	SrcSymlink string
	ModDir     string
}

func detectConfigActions(modDir string) ([]Action, error) {
	var actions []Action

	modEntries, err := os.ReadDir(modDir)
	if err != nil {
		return nil, fmt.Errorf("can't read mod dir: %w", err)
	}

	for _, modEntry := range modEntries {
		if modEntry.Name() == ".config" {
			actions = append(actions, Action{
				ConfigAction: &ConfigAction{
					Name:       filepath.Base(modDir),
					SrcSymlink: filepath.Join(modDir, modEntry.Name()),
					ModDir:     modDir,
				},
			})
		}
	}

	return actions, nil
}

type BinAction struct {
	Name       string
	SrcSymlink string
	ModDir     string
}

func detectBinActions(modDir string) ([]Action, error) {
	var actions []Action

	modEntries, err := os.ReadDir(modDir)
	if err != nil {
		return nil, fmt.Errorf("can't read mod dir: %w", err)
	}

	for _, modEntry := range modEntries {
		if modEntry.Name() == ".bin" {
			binEntries, err := os.ReadDir(modDir)
			if err != nil {
				return nil, fmt.Errorf("can't read mod bin dir: %w", err)
			}

			for _, binEntry := range binEntries {
				actions = append(actions, Action{
					BinAction: &BinAction{
						Name:       binEntry.Name(),
						SrcSymlink: filepath.Join(modDir, modEntry.Name(), binEntry.Name()),
						ModDir:     modDir,
					},
				})
			}
		}
	}

	return actions, nil
}

func dotfilesDir() string {
	_, mainFile, _, ok := runtime.Caller(0)
	if !ok {
		slog.Error("caller not ok")
		return ""
	}
	modDir := filepath.Dir(mainFile)
	rootDir := filepath.Dir(modDir)
	return rootDir
}

func homeDir() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(fmt.Errorf("can't get home dir: %w", err))
	}
	return homeDir
}
