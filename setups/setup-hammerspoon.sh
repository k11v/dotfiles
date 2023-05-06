#!/bin/sh

if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/assert.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"
source "$DOTFILES_SETUP_MIXINS/link.sh"
source "$DOTFILES_SETUP_MIXINS/require.sh"


require_environment
require_macos
require_macos_application "Hammerspoon"

assert_non_empty_string "$1" "Configuration directory from Dotfiles 'hammerspoon.dotfiles' is not provided (1st positional argument)"
assert_absolute_path "$1"
assert_directory "$1"


any_success=0
any_failure=0


# Setup app preferences using macOS defaults

defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool false  # Hide the Dock icon
defaults write org.hammerspoon.Hammerspoon MJShowMenuIconKey -bool false  # Hide the menu bar icon
any_success=1


# Symlink the ~/.hammerspoon directory

src_hammerspoon_dir="$1/.hammerspoon"
dst_hammerspoon_dir="$HOME/.hammerspoon"

dst_hammerspoon_dir_parent_dir="$(dirname "$dst_hammerspoon_dir")"
mkdir -p "$dst_hammerspoon_dir_parent_dir"
if [ ! -d "$dst_hammerspoon_dir_parent_dir" ]; then
    echo >&2 "$(basename "$0"): $dst_hammerspoon_dir_parent_dir: Failed to provide a directory for symlinks"
    exit 1
fi

link "$src_hammerspoon_dir" "$dst_hammerspoon_dir"
[ "$?" -eq 0 ] && any_success=1 || any_failure=1


killall "Hammerspoon" &> /dev/null
[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
