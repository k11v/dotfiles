HISTFILE="$HOME/.local/state/zsh/.zhistory"
ZCOMPCACHE="$HOME/.cache/zsh/.zcompcache" # user-defined
ZCOMPDUMP="$HOME/.cache/zsh/.zcompdump" # user-defined
ZDOTDIR="$HOME/.config/zsh"
[[ ! -e "$HOME/.cache/zsh" ]] || mkdir -p "$HOME/.cache/zsh"
[[ ! -e "$HOME/.local/state/zsh" ]] && mkdir -p "$HOME/.local/state/zsh"
