package main

import (
	"context"
	"fmt"
	"log/slog"
	"os"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	os.Exit(0)
}

func run() error {
	ctx := context.Background()
	moduleDirs := os.Args[1:]

	for _, moduleDir := range moduleDirs {
		doModule(ctx, moduleDir)
	}

	return nil
}

func doModule(ctx context.Context, moduleDir string) {
	slog.InfoContext(ctx, "started doing module", "module_dir", moduleDir)
	defer slog.InfoContext(ctx, "stopped doing module", "module_dir", moduleDir)
}
