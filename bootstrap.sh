#! /bin/bash


# note: it doesn't follow symlinks
dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"


# ---------------------------------------------------------------------------- #
# Packages installation
# ---------------------------------------------------------------------------- #


# install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install Homebrew packages
brew bundle --file "$dotfiles_dir/Brewfile"


# ---------------------------------------------------------------------------- #
# `clifiles` installation
# ---------------------------------------------------------------------------- #


# macOS comes preloaded with Zsh (however, it can be outdated)
zsh $dotfiles_dir/clifiles/install.sh
