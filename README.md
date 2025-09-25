# Dotfiles

Dotfiles contains configuration files for programs that I use on a daily basis and a tool to install them on my personal computer.

## Design

The design is modular. Each module represents a program. Each program is set up in one of the three ways:

- Files (e.g. `$HOME/.config/nvim/init.lua`): Setup links files.
- Environment variables (e.g. `GOPROXY`): Setup generates an `env` file which is sourced by shells.
- Arguments (e.g. `tmux -f /path/to/tmux.conf`): Setup links wrapper executables which are found on PATH.
