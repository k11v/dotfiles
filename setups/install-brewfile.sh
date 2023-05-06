#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
assert_non_empty_string "$1" "Argument 1 must be a path to a Brewfile"

require_command brew


brew bundle install --file "$1"

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
