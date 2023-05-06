require_environment() {
    if [ "$DOTFILES_ENVIRONMENT_LOADED" -ne 1 ]; then
        echo >&2 "$(basename "$0"): Unmet requirement: Dotfiles environment must be loaded"
        exit 2
    fi
}

require_command() {
    if ! command -v "$1" &> /dev/null; then
        echo >&2 "$(basename "$0"): Unmet requirement: Command '$1' must exist"
        exit 2
    fi
}

require_macos() {
    if [ "$(uname -s 2> /dev/null)" != "Darwin" ]; then
        echo >&2 "$(basename "$0"): Unmet requirement: Platform must be macOS"
        exit 2
    fi
}

require_macos_application() {
    if [ -z "$(mdfind -name "$1.app" 2> /dev/null)" ]; then
        echo >&2 "$(basename "$0"): Unmet requirement: Application '$1' must be installed"
        exit 2
    fi
}
