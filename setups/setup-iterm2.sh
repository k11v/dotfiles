#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
require_macos
require_macos_application "iTerm"

assert_non_empty_string "$1" "First argument (dotfiles-iterm2-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$1"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

exit_with_success
