#!/bin/sh

usage() {
    cat << EOF
Usage: $0 [options]

Options:
  -h, --help      Show this message.
  --[no-]macbook  Run/skip MacBook specific setups.
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
    echo "$(tput bold)$1$(tput sgr0)"
}

highlight() {
    echo "$(tput setaf 3)$1$(tput sgr0)"
}

signal() {
    for i in {1.."$1"}; do tput bel; sleep 0.3; done
}


macbook=""

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


if [ -z "$macbook" ]; then
    if confirm "Would you like to run MacBook specific setups? [Y/n] "; then
        macbook=1
    else
        macbook=0
    fi
fi


root="$(cd -- "$(dirname -- "$0")" > /dev/null && pwd)"
setups="$root/setups"
dotfiles="$root/dotfiles"


environment="$dotfiles/cfgs/zsh/variables.zsh"
source "$environment"

if [ "$?" -ne 0 ]; then
    echo >&2 "Couldn't load environment: $environment"
    eixt 1
fi


section "Installing Homebrew"
"$setups/install-homebrew.sh"
signal 1

section "Installing Brewfile"
"$setups/install-brewfile.sh" "$dotfiles/Brewfile"
signal 1

section "Symlinking binaries from bin/"
"$setups/symlink-bin.sh" "$dotfiles/bin"

section "Symlinking configs from config/"
"$setups/symlink-config.sh" "$dotfiles/config"

section "Symlinking home files from home/"
"$setups/symlink-home.sh" "$dotfiles/home"

section "Setting up macOS"
"$setups/setup-macos.sh"

if [ "$macbook" -eq 1 ]; then
    section "Setting up macOS (MacBook specific)"
    "$setups/setup-macos.macbook.sh"
fi

section "Setting up apps"
"$setups/setup-apps.sh"

section "Setting up fzf"
"$setups/setup-fzf.sh"

section "Setting up pyenv"
"$setups/setup-pyenv.sh"

section "Setting up tldr"
"$setups/setup-tldr.sh"

section "Setting up iterm2"
"$setups/setup-iterm2.sh" "$dotfiles/config/iterm2"

section "Setting up sublime-text"
"$setups/setup-sublime-text.sh" "$dotfiles/config/sublime-text"


section "$(highlight 'Dotfiles setup complete!')"
highlight "Now do a restart to make some of these changes take effect."
signal 3
