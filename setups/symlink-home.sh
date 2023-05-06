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


assert_non_empty_string "$1" "First argument (dotfiles-home-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


src_home="$1"
dst_home="$HOME"

mkdir -p "$dst_home"
if [ ! -d "$dst_home" ]; then
    echo >&2 "$(basename "$0"): $dst_home: Failed to provide a directory for symlinks"
    exit 1
fi

any_success=0
any_failure=0
for file in "$src_home/".*; do
    filename="$(basename "$file")"

    [ "$filename" = "." ] && continue
    [ "$filename" = ".." ] && continue
    [ "$filename" = ".DS_Store" ] && continue

    link "$src_home/$filename" "$dst_home/$filename"
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
done

[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
