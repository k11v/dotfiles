# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repo organized as **modules** — each top-level directory (e.g. `nvim/`, `zsh/`, `git/`) is a self-contained module with its own config files, integrations, and optional Brewfile.

## Install Command

```sh
dotfiles="$HOME/Repositories/dotfiles/dot/.bin/dot"
caffeinate -d "$dotfiles" "$HOME"/Repositories/dotfiles/*
```

The `dot` script (`dot/.bin/dot`) is the installer. It takes module directories as arguments and for each one:
1. Removes broken symlinks from previous installs (`unsymlink`)
2. Symlinks `.home/` files to `$HOME`
3. Symlinks `.bin/` scripts to `$HOME/.local/bin`
4. Symlinks `.config/` directories to `$HOME/.config`
5. Symlinks `.integration/zsh/*.zsh` to `$HOME/.local/share/zsh/integration/` (sourced by `.zshrc`)
6. Assembles `.integration/gitignore/`, `.integration/gitconfig/`, `.integration/gitconfigopt/` into combined git config files
7. Symlinks `.integration/tldr/` patches
8. Runs `brew bundle` for `.brewfile` if present
9. Runs the Go-based `dot v2` tool (`dot/main.go`) which handles `.config.tmpl/` — Go `text/template` files rendered to `$HOME/.config` (template function: `homeDir`)

## Module Convention

Each module directory can contain any combination of:
- `.config/` — symlinked into `$HOME/.config/`
- `.config.tmpl/` — rendered via Go templates into `$HOME/.config/` (files ending in `.tmpl` are processed, others are copied)
- `.home/` — symlinked into `$HOME/`
- `.bin/` — symlinked into `$HOME/.local/bin/`
- `.integration/zsh/` — zsh scripts sourced on shell init
- `.integration/gitignore/` — combined into a global gitignore
- `.integration/gitconfig/` — combined into a global git include
- `.integration/gitconfigopt/` — optional git config includes
- `.integration/tldr/` — tldr page patches
- `.brewfile` — Homebrew dependencies

## Build / Run the Go Tool

```sh
cd dot && go build -o /tmp/dot-v2 .
```

No tests exist. The Go module is at `dot/go.mod` (module `github.com/k11v/dotfiles/dot`, Go 1.24.5).

## Key Details

- The `private/` module contains work-specific config and has its own `.gitignore`
- Neovim config is in `nvim/.config/nvim/` with Lua modules under `lua/internal/`
- Zsh integration files from all modules are sourced via a glob in `zsh/.config/zsh/.zshrc`: `$HOME/.local/share/zsh/integration/*.zsh`
- The `.gitignore` is inverted — it ignores everything by default and explicitly allows dotfiles and known paths
