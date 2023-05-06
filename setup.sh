#!/bin/sh

usage() {
    cat << EOF
Usage: $0 [options]

Options:
  -h, --help           Show this message.
  -s, --symlinks-only  Run only symlinking setups
  --[no-]macbook       Run/skip MacBook specific setups.
EOF
}

confirm() {
    printf >&2 '%s' "$1"
    read -r answer

    case "$answer" in
        [Yy]*) return 0;;
    esac

    return 1
}

section() {
    echo "$(tput bold)$(tput setaf 3)$1$(tput sgr0)"
}

section_partially_successful() {
    echo "$(tput bold)$(tput setaf 3)$1$(tput sgr0)"
}

section_skipped() {
    echo "$(tput bold)$(tput setaf 0)$1$(tput sgr0)"
}

section_failed() {
    echo "$(tput bold)$(tput setaf 1)$1$(tput sgr0)"
}

highlight() {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

successful_setups=0
partially_successful_setups=0
skipped_setups=0
failed_setups=0

handle_exit() {
    if [ "$1" -eq 0 ]; then
        successful_setups="$((successful_setups + 1))"
    elif [ "$1" -eq 4 ]; then
        partially_successful_setups="$((partially_successful_setups + 1))"
        section_partially_successful "Partially succeeded"
    elif [ "$1" -eq 2 ]; then
        skipped_setups="$((skipped_setups + 1))"
        section_skipped "Skipped"
    elif [ "$1" -eq 1 ] || [ "$1" -eq 3 ]; then
        failed_setups="$((failed_setups + 1))"
        section_failed "Failed"
    else
        failed_setups="$((failed_setups + 1))"
        section_failed "Failed with unexpected exit code"
    fi
}

# Handle arguments

symlinks_only=0
macbook=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -s|--symlinks-only)
            symlinks_only=1
            shift
            ;;
        --macbook)
            macbook=1
            shift
            ;;
        --no-macbook)
            macbook=0
            shift
            ;;
        *)
            echo >&2 "Unknown option: $1"
            usage >&2
            exit 1
            ;;
    esac
done

# Prepare environment

root="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"
setups="$root/setups"
dotfiles="$root/dotfiles"

environment="$dotfiles/config/zsh/variables.zsh"
source "$environment"

if [ "$?" -ne 0 ]; then
    echo >&2 "Couldn't load environment: $environment"
    exit 1
fi

# Set up if symlinks only

if [ "$symlinks_only" -eq 1 ]; then
    section "Symlinking binaries from bin/"
    "$setups/symlink-bin.sh" "$dotfiles/bin"

    section "Symlinking configs from config/"
    "$setups/symlink-config.sh" "$dotfiles/config"

    section "Symlinking home files from home/"
    "$setups/symlink-home.sh" "$dotfiles/home"

    exit "$?"
fi

# Prepare for general setup

if [ -z "$macbook" ]; then
    if confirm "Would you like to run MacBook specific setups? [Y/n] "; then
        macbook=1
    else
        macbook=0
    fi
fi

# Set up

section "Installing Homebrew"
"$setups/install-homebrew.sh"
handle_exit "$?"

section "Installing Brewfile"
"$setups/install-brewfile.sh" "$dotfiles/Brewfile"
handle_exit "$?"

section "Symlinking binaries from bin/"
"$setups/symlink-bin.sh" "$dotfiles/bin"
handle_exit "$?"

section "Symlinking configs from config/"
"$setups/symlink-config.sh" "$dotfiles/config"
handle_exit "$?"

section "Symlinking home files from home/"
"$setups/symlink-home.sh" "$dotfiles/home"
handle_exit "$?"

section "Setting up macOS"
"$setups/setup-macos.sh"
handle_exit "$?"

if [ "$macbook" -eq 1 ]; then
    section "Setting up macOS (MacBook specific)"
    "$setups/setup-macos.macbook.sh"
    handle_exit "$?"
fi

section "Setting up fzf"
"$setups/setup-fzf.sh"
handle_exit "$?"

section "Setting up tldr"
"$setups/setup-tldr.sh"
handle_exit "$?"

section "Setting up sublime-text"
"$setups/setup-sublime-text.sh" "$dotfiles/config/sublime-text.dotfiles"
handle_exit "$?"

section "Setting up amphetamine"
"$setups/setup-amphetamine.sh"
handle_exit "$?"

section "Setting up flow"
"$setups/setup-flow.sh"
handle_exit "$?"

section "Setting up rectangle"
"$setups/setup-rectangle.sh"
handle_exit "$?"

section "Setting up telegram"
"$setups/setup-telegram.sh"
handle_exit "$?"

section "Setting up transmission"
"$setups/setup-transmission.sh"
handle_exit "$?"

section "Setting up hammerspoon"
"$setups/setup-hammerspoon.sh" "$dotfiles/config/hammerspoon.dotfiles"
handle_exit "$?"


section "Dotfiles setup complete:"
[ "$successful_setups" -gt 0 ]           && echo "  $(tput bold)$(tput setaf 3)- $successful_setups $(tput setaf 2)successful$(tput setaf 3) setup(s)$(tput sgr0)"
[ "$partially_successful_setups" -gt 0 ] && echo "  $(tput bold)$(tput setaf 3)- $partially_successful_setups $(tput setaf 4)partially successful$(tput setaf 3) setup(s)$(tput sgr0)"
[ "$skipped_setups" -gt 0 ]              && echo "  $(tput bold)$(tput setaf 3)- $skipped_setups $(tput setaf 7)skipped$(tput setaf 3) setup(s)$(tput sgr0)"
[ "$failed_setups" -gt 0 ]               && echo "  $(tput bold)$(tput setaf 3)- $failed_setups $(tput setaf 1)failed$(tput setaf 3) setup(s)$(tput sgr0)"
highlight "Now do a restart to make some of these changes take effect."
