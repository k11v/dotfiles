#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

dotfiles-file "$HOME"/.config/zsh config
dotfiles-file "$HOME"/.zshenv .zshenv
