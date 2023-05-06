#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/assert.sh"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment

require_command fzf
require_command brew


"$(brew --prefix)/opt/fzf/install" --xdg --key-bindings --completion --no-update-rc

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
