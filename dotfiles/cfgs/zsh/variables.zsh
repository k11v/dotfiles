# Global

export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"

# Zsh

export FPATH="$XDG_CONFIG_HOME/zsh/completions:$FPATH"
PROMPT_EOL_MARK=""
PS2="%B…%b "
HISTFILE="$XDG_DATA_HOME/zsh/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"

# Less

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS="-g -i -M -R -S -x4"

# GNU utils

export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32"
export GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"

# Pyenv

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# My utils

export REPOSITORIES="$HOME/Repositories"
export TOOLKITS="$HOME/.config/toolkit/kits"
