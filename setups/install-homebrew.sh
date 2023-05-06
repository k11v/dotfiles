#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/exit.sh"
source "$mixins/require.sh"


assert_loaded_environment
require_macos


if command -v brew &> /dev/null; then
    exit_with_success "Already installed."
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if command -v brew &> /dev/null; then
    exit_with_success
else
    exit_with_failure
fi
