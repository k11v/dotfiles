#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
require_command tldr


tldr --update  # Implementation specific, works for 'tealdeer'

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
