package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
)

func main() { os.Exit(run()) }

func run() int {
	if err := runCLI(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		return 1
	}
	return 0
}

func runCLI() error {
	home, err := os.UserHomeDir()
	if err != nil {
		return err
	}
	flags := flag.NewFlagSet("make-xray-config", flag.ContinueOnError)
	input := flags.String("input", filepath.Join(home, ".local", "share", "xray", "integration"), "directory containing TAG.json outbound definitions")
	output := flags.String("output", filepath.Join(home, ".config", "xray", "config.json"), "config destination")
	flags.Usage = func() {
		fmt.Fprintln(flags.Output(), "Usage: make-xray-config [--input DIR] [--output PATH]")
		flags.PrintDefaults()
	}
	if err := flags.Parse(os.Args[1:]); err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return nil
		}
		return err
	}
	if flags.NArg() != 0 {
		return errors.New("unexpected arguments; put VLESS links in the input directory as TAG.json")
	}
	data, err := makeConfigFromDir(*input)
	if err != nil {
		return err
	}
	if err := writeConfig(*output, data); err != nil {
		return err
	}
	fmt.Printf("Wrote %s\n", *output)
	return nil
}

func writeConfig(output string, data []byte) error {
	// Older installations symlinked this directory into the dotfiles repository.
	// Check every existing path component before creating directories or files.
	path, err := filepath.Abs(output)
	if err != nil {
		return err
	}
	for current := path; ; current = filepath.Dir(current) {
		info, err := os.Lstat(current)
		if err != nil && !errors.Is(err, os.ErrNotExist) {
			return err
		}
		if err == nil && info.Mode()&os.ModeSymlink != 0 {
			return fmt.Errorf("refusing to write config through symlink %s; choose a local config destination", current)
		}
		if filepath.Dir(current) == current {
			break
		}
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return err
	}
	file, err := os.CreateTemp(filepath.Dir(path), ".config-*.json")
	if err != nil {
		return err
	}
	defer os.Remove(file.Name())
	defer file.Close()
	if _, err := file.Write(data); err != nil {
		return err
	}
	if err := file.Close(); err != nil {
		return err
	}
	return os.Rename(file.Name(), path)
}
