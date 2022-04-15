#!/bin/sh

if [ "$DOTFILES_ENVIRONMENT_LOADED" -ne 1 ]; then
    echo >&2 "$(basename "$0"): Environment doesn't seem to be loaded"
    exit 1
fi
if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/require.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"


require_command fzf
require_command brew


"$(brew --prefix)/opt/fzf/install" --xdg --key-bindings --completion --no-update-rc

if [ "$?" -eq 0 ]; then
    exit_with_success
else
    exit_with_failure
fi
