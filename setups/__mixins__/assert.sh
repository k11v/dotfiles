assert_non_empty_string() {
    if [ -z "$1" ]; then
        echo >&2 "$(basename "$0"): $2"
        exit 1
    fi
}

assert_absolute_path() {
    if [ "$(printf "%s" "$1" | cut -c1)" != "/" ]; then
        echo >&2 "$(basename "$0"): $1: Not an absolute path"
        exit 1
    fi
}

assert_directory() {
    if [ ! -d "$1" ]; then
        echo >&2 "$(basename "$0"): $1: Not a directory"
        exit 1
    fi
}

assert_non_empty_xdg_variables() {
    if [ -z "$XDG_CONFIG_HOME" ]; then
        echo >&2 "$(basename "$0"): XDG_CONFIG_HOME is missing"
        exit 1
    fi
    if [ -z "$XDG_CACHE_HOME" ]; then
        echo >&2 "$(basename "$0"): XDG_CACHE_HOME is missing"
        exit 1
    fi
    if [ -z "$XDG_DATA_HOME" ]; then
        echo >&2 "$(basename "$0"): XDG_DATA_HOME is missing"
        exit 1
    fi
    if [ -z "$XDG_STATE_HOME" ]; then
        echo >&2 "$(basename "$0"): XDG_STATE_HOME is missing"
        exit 1
    fi
}
