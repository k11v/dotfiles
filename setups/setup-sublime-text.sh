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
require_macos_application "Sublime Text"

assert_non_empty_string "$1" "First argument (dotfiles-sublime-text-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


src_packages="$1/Packages"
dst_packages="$HOME/Library/Application Support/Sublime Text/Packages"

mkdir -p "$dst_packages"
if [ ! -d "$dst_packages" ]; then
    echo >&2 "$(basename "$0"): $dst_packages: Failed to provide a directory for symlinks"
    exit 1
fi

any_success=0
any_failure=0
for file in "$src_packages/"*; do
    filename="$(basename "$file")"
    link "$src_packages/$filename" "$dst_packages/$filename"
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
done

[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
