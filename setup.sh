#!/bin/sh

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

for file in *; do
    if [ -e "$file/setup.sh" ]; then
        "$file/setup.sh"
    fi
done
