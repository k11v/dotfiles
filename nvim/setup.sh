#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

dotfiles-link "$HOME"/.config/nvim config
