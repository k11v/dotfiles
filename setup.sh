#!/bin/sh

usage() {
    cat >&2 << EOF
Usage: $0 [options]

Options:
  -h, --help      Show this message.
  --[no-]macbook  Run/skip MacBook specific setups.
EOF
}

macbook=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        --macbook)
            macbook=1
            shift
            ;;
        *)
            echo >&2 "Unknown option: $1"
            usage
            exit 0
            ;;
    esac
done
