#!/bin/sh

if [ -z "$1" ]; then
    echo >&2 "$(basename "$0"): brewfile was not provided"
    exit 1
fi

brew bundle install --file "$1"
