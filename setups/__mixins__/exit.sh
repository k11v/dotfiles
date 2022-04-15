exit_with_success() {
    if [ -n "$1" ]; then
        echo "$1"
    fi
    exit 0
}

exit_with_failure() {
    if [ -n "$1" ]; then
        echo >&2 "$1"
    fi
    exit 3
}

exit_with_partial_success() {
    if [ -n "$1" ]; then
        echo >&2 "$1"
    fi
    exit 4
}
