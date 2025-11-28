ZDOTDIR="$HOME/.config/zsh"

if [[ -e "$HOME"/.local/share/dotfiles/env ]]; then
    source "$HOME"/.local/share/dotfiles/env
fi

export EDITOR="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export PAGER="less"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export VISUAL="nvim"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# See "brew info libpq".
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include $CPPFLAGS"

export GOPATH="$XDG_DATA_HOME/go"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS="-g -i -M -R -S -x4 --mouse --wheel-lines=5"

export LEDGER_FILE="$HOME/Repositories/finances/main.journal"

# e.g. to get correct kubectl to work with clusters
export PATH="$HOME/.avito/bin:$PATH"
export PATH="$HOME/Repositories/dotfiles/dotfiles/bin:$PATH"

export http_proxy="http://127.0.0.1:1081"
export https_proxy="http://127.0.0.1:1081"
