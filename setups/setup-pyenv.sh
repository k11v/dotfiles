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


require_command pyenv


any_success=0
any_failure=0

# Check existing venvs

scripts_venv_exists=0
shared_venv_exists=0

if [ "$(pyenv virtualenvs --bare | grep -E "^scripts$")" = "scripts" ]; then
    scripts_venv_exists=1
fi

if [ "$(pyenv virtualenvs --bare | grep -E "^shared$")" = "shared" ]; then
    shared_venv_exists=1
fi

# If needed, install the latest Python

latest_python_version="$(pyenv install --list | grep -E "^\s*\d+(\.\d+)*\s*$" | tail -1 | xargs)"

if [ "$scripts_venv_exists" -ne 1 ] || [ "$scripts_venv_exists" -ne 1 ]; then
    echo "$(tput bold)Installing latest Python ($latest_python_version)$(tput sgr0)"
    pyenv install --skip-existing "$latest_python_version"
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
fi

# If needed, create 'scripts' venv

echo "$(tput bold)Creating 'scripts' venv$(tput sgr0)"
if [ "$scripts_venv_exists" -ne 1 ]; then
    pyenv virtualenv "$latest_python_version" scripts
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
else
    echo "Already exists."
fi

# If needed, create 'shared' venv

echo "$(tput bold)Creating 'shared' venv$(tput sgr0)"
if [ "$shared_venv_exists" -ne 1 ]; then
    pyenv virtualenv "$latest_python_version" shared
    [ "$?" -eq 0 ] && any_success=1 || any_failure=1
else
    echo "Already exists."
fi

# Make 'shared' venv global

echo "$(tput bold)Making 'shared' venv global$(tput sgr0)"
pyenv global shared
[ "$?" -eq 0 ] && any_success=1 || any_failure=1


[ "$any_failure" -eq 0 ] && exit_with_success
[ "$any_success" -eq 1 ] && exit_with_partial_success
exit_with_failure
