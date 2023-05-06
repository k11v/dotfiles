#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/link.sh"
source "$mixins/require.sh"


assert_loaded_environment

assert_non_empty_string "$1" "First argument (dotfiles-bin-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


src_bin="$1"
dst_bin="$HOME/.local/bin"

mkdir -p "$dst_bin"
if [ ! -d "$dst_bin" ]; then
    echo >&2 "$(basename "$0"): $dst_bin: Failed to provide a directory for symlinks"
    exit 1
fi

any_success=0
any_failure=0
for file in "$src_bin/"*; do
    filename="$(basename "$file")"
    link "$src_bin/$filename" "$dst_bin/$filename"
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
done

[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
