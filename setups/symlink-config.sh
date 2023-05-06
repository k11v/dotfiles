#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/link.sh"
source "$mixins/require.sh"


assert_loaded_environment

assert_non_empty_xdg_variables
assert_non_empty_string "$1" "First argument (dotfiles-config-directory) is missing"
assert_absolute_path "$1"
assert_directory "$1"


src_config="$1"
dst_config="$XDG_CONFIG_HOME"

mkdir -p "$dst_config"
if [ ! -d "$dst_config" ]; then
    echo >&2 "$(basename "$0"): $dst_config: Failed to provide a directory for symlinks"
    exit 1
fi

any_success=0
any_failure=0
for file in "$src_config/"*; do
    filename="$(basename "$file")"
    link "$src_config/$filename" "$dst_config/$filename"
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
done

[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
