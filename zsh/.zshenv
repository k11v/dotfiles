ZDOTDIR="$HOME/.config/zsh"

source "$HOME/.local/share/dotfiles/current/env.sh"

# WTF: Stop macOS's Terminal.app from littering in my 'ZDOTDIR' with
# '.zsh_sessions/' (see https://apple.stackexchange.com/q/427561).
SHELL_SESSIONS_DISABLE=1
