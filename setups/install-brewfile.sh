#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


require_environment
require_command brew

assert_non_empty_string "$1" "First argument (brewfile) is missing"


brew bundle install --file "$1"

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
