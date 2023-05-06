#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/link.sh"
source "$mixins/require.sh"


assert_loaded_environment
assert_non_empty_string "$1" "Argument 1 must be a path to 'config/sublime-text.dotfiles'"
assert_absolute_path "$1"
assert_directory "$1"

require_macos
require_macos_application "Sublime Text"


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
