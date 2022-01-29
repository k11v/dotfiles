#!/bin/sh

if command -v brew &> /dev/null; then
    echo "Already installed."
    exit 0
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
