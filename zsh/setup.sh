#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

dotfiles-link "$HOME"/.config/zsh config
dotfiles-link "$HOME"/.zshenv .zshenv
