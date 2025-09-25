#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

dotfiles-file "$HOME"/.config/nvim config
