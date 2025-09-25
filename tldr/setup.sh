#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

dotfiles-line-file "$HOME"/.local/share/dotfiles/env env
