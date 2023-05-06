#!/bin/sh

if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/exit.sh"
source "$DOTFILES_SETUP_MIXINS/require.sh"


require_environment
require_command tldr


tldr --update  # Implementation specific, works for 'tealdeer'

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
