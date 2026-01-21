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
	var actions []Action

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
			modDir := filepath.Join(dotfilesDir, dotfilesEntry.Name())
			actions2, err := detectActions(modDir)
			if err != nil {
				slog.Error("detecting actions failed", "modDir", modDir, "error", err)
			}
			actions = append(actions, actions2...)
		}
	}

	fmt.Printf("%#v\n", actions[0].ConfigAction)

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

func doActions(actions []Action) error {
	var err error

	for _, action := range actions {
		switch {
		case action.ConfigAction != nil:
			err2 := doConfigAction(action.ConfigAction)
			err = errors.Join(err, err2)
		case action.BinAction != nil:
			err2 := doBinAction(action.BinAction)
			err = errors.Join(err, err2)
		}
	}
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

func doConfigAction(configAction *ConfigAction) error {
	// Make old name.

	if configAction.SrcSymlink == "" {
		return errors.New("config: empty src")
	}

	oldName := configAction.SrcSymlink

	// Make new name.

	if configAction.Name == "" {
		return errors.New("config: empty name")
	}

	newName := filepath.Join(homeDir(), ".config", configAction.Name)

	// Check new name.

	newNameFileInfo, err := os.Stat(newName)

	if errors.Is(err, fs.ErrNotExist) {
		// OK.
	} else if err != nil {
		// Not OK.
	} else {
		mode := newNameFileInfo.Mode()
		isSymlink := mode & ModeSymlink != 0

		if !isSymlink {
			// Not OK.
		}

		// Read symlink...

		// If destination equals wanted destination, then OK, else not OK.
	}

	// Symlink.

	err := os.Symlink(oldName, newName)
	if err != nil {
		return fmt.Errorf("config: %w", err)
	}

	return nil
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
		if modEntry.Name() == ".bin.d" {
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

func doBinAction(binAction *BinAction) error {
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
