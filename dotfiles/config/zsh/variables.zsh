# Global

export EDITOR="nvim"
export VISUAL="nvim"
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
KEYTIMEOUT=1

ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"  # User-defined
PROMPT_STYLE="regular"                      # User-defined

# Less

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS="-g -i -M -R -S -x4 --mouse --wheel-lines=5"

# GNU utils

export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32"
export GREP_COLORS="ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36"

# Pip

export PIP_REQUIRE_VIRTUALENV=true

# Pyenv

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Bat

export BAT_PAGER=""

# My utils

export VENVS="$XDG_DATA_HOME/venvs"
export REPOSITORIES="$HOME/local/repositories"
export SPACES="$HOME/local/spaces"
export DOTFILES_ENVIRONMENT_LOADED=1

# Homebrew

# binutils. Not symlinked by default. Provides GNU `strings`, etc.
export PATH="/usr/local/opt/binutils/bin:$PATH"
export MANPATH="/usr/local/opt/binutils/share/man:$MANPATH"

# coreutils. G-prefixed by default. Provides GNU `cp`, `ls`, `rm`, etc.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# findutils. G-prefixed by default. Provides GNU `find`, `xargs`, etc.
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

# gawk. G-prefixed by default. Provides GNU `awk`.
export PATH="/usr/local/opt/gawk/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gawk/libexec/gnuman:$MANPATH"

# gnu-getopt. Not symlinked by default. Provides GNU `getopt`.
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export MANPATH="/usr/local/opt/gnu-getopt/share/man:$MANPATH"

# gnu-indent. G-prefixed by default. Provides GNU `indent`.
export PATH="/usr/local/opt/gnu-indent/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gnu-indent/libexec/gnuman:$MANPATH"

# gnu-sed. G-prefixed by default. Provides GNU `sed`.
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

# gnu-tar. G-prefixed by default. Provides GNU `tar`.
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

# grep. G-prefixed by default. Provides GNU `egrep`, `fgrep`, `grep`.
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

# inetutils. Partly G-prefixed by default. Provides GNU `hostname`, `ping`, etc.
export PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/inetutils/libexec/gnuman:$MANPATH"

# make. G-prefixed by default. Provides GNU `make`.
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/make/libexec/gnuman:$MANPATH"

# libpq. Not symlinked by default. Provides `pg_dump`, `psql`, etc.
export PATH="/usr/local/opt/libpq/bin:$PATH"
export MANPATH="/usr/local/opt/libpq/share/man:$MANPATH"

# mysql-client. Not symlinked by default. Provides `mysql`, etc.
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export MANPATH="/usr/local/opt/mysql-client/share/man:$MANPATH"
