#!/bin/sh

# Install latest Python

latest_python_version="$(pyenv install --list | grep -E "^\s*\d+(\.\d+)*\s*$" | tail -1 | xargs)"

echo "$(tput setaf 3)Installing latest Python ($latest_python_version)$(tput sgr0)"
pyenv install "$latest_python_version"

# Create 'scripts' venv

echo "$(tput setaf 3)Creating 'scripts' venv from $latest_python_version$(tput sgr0)"
pyenv virtualenv "$latest_python_version" scripts

# Create global 'shared' venv

echo "$(tput setaf 3)Creating global 'shared' venv from $latest_python_version$(tput sgr0)"
pyenv virtualenv "$latest_python_version" shared
pyenv global shared
