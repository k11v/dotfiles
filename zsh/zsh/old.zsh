export PATH="/opt/homebrew/opt/libpq/bin:$PATH" # brew install libpq
export PATH="$PATH:/opt/homebrew/opt/git/bin" # use newer Git from Homebrew
export PATH="$PATH:$HOME/.local/dist/nvim/bin"

# Cursor

# Default cursor.
function _cursor_precmd() {
   printf "\e[6 q" # beam
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _cursor_precmd

# History

# HISTFILE="$HOME/.local/share/zsh/.zhistory" # set in the main .zshrc
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY # Save each command's timestamp in history

# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
function _search_history() {
    local selected num ret
    # '--no-clear-start' fixes https://github.com/lotabout/skim/issues/494
    selected="$(fc -lr 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --exact --no-sort --no-clear-start --height 40% -n2.. --query "$BUFFER")"
    ret="$?"
    if [[ -n "$selected" ]]; then
        num="$(awk '{print $1}' <<< "$selected")"
        if [[ "$num" =~ '^[1-9][0-9]*\*?$' ]]; then
            zle vi-fetch-history -n "${num%\*}"
        else
            BUFFER="$selected"
        fi
    fi
    zle reset-prompt
    return "$ret"
}
zle -N _search_history
bindkey "^R" _search_history

# Prompt

PROMPT_EOL_MARK=""
PS2="%B…%b "
function _prompt_precmd() {
    local exit_status="$?" git_ref git_commit git_tag is_git_worktree
    local username hostname branch context venv workdir symbol
    
    workdir="%B%F{cyan}%~%f%b"
    symbol="%B%F{green}❯%f%b"

    # is_git_worktree is "true", "false", or "" (when not in a Git repository).
    is_git_worktree="$(git rev-parse --is-inside-work-tree 2> /dev/null)"

    if [[ "$is_git_worktree" == "true" ]]; then
        git_ref="$(git symbolic-ref --quiet HEAD 2> /dev/null)"
        [[ "$?" -eq 1 ]] && git_commit="$(git rev-parse --short HEAD 2> /dev/null)"
        [[ -n "$git_commit" ]] && git_tag="$(git describe --exact-match --tags "$git_commit" 2> /dev/null)"

        if [[ -d ".git" ]]; then
            workdir="%B%F{cyan}${PWD:t}%f%b"
        fi

        if [[ -n "$git_ref" ]]; then
            branch=" on %B%F{magenta}${git_ref#refs/heads/}%f%b"
        elif [[ -n "$git_tag" ]]; then
            branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($git_tag)%b%f"
        elif [[ -n "$git_commit" ]]; then
            branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($git_commit)%b%f"
        fi
    elif [[ "$is_git_worktree" == "false" ]]; then
        branch=" on %B%F{magenta}HEADLESS%f%b"
    fi

    if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
        username="%B%F{yellow}%n%f%b in "
        hostname="%B%F{green}%m%f%b in "
    fi

    if [[ "${EUID-}" -eq 0 ]]; then
        username="%B%F{red}%n%f%b in "
    fi

    if [[ -n "${X_CONTEXT-}" ]]; then
        context=" via %B%F{blue}${X_CONTEXT}%f%b"
    fi

    if [[ -n "${VIRTUAL_ENV-}" ]]; then
        venv=" via %B%F{yellow}${VIRTUAL_ENV:t}%f%b"
    elif [[ -n "${PYENV_VERSION-}" ]]; then
        venv=" via %B%F{yellow}${PYENV_VERSION}%f%b"
    fi

    if [[ "$exit_status" -ne 0 ]]; then
        symbol="%B%F{red}❯%f%b"
    fi

    PROMPT="$username$hostname$workdir$branch$context$venv $symbol "
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd

# Aliases

alias sudo="sudo " # enables sudo for aliases

alias dcb="docker compose build"
alias dcd="docker compose down"
alias dcdv="docker compose down -v"
alias dce="docker compose exec"
alias dcl="docker compose logs"
alias dclf="docker compose logs -f"
alias dcp="docker compose ps"
alias dcpa="docker compose ps -a"
alias dcr="docker compose run"
alias dcrr="docker compose run --rm"
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias ga="git add"
alias gap="git add --patch"
alias gb="git branch"
alias gc="git-commit--issue"  # git-commit--issue is user-defined
alias gcf="git commit --fixup"
alias gca="git commit --amend"
alias gci='git commit --allow-empty -m "Initial commit"'
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gcu='git reset --soft HEAD~1'  # [U]ndo the last [c]ommit
alias gcw='git commit -m "wip"'
alias gd="git diff"
alias gdq="git--quiet diff"  # git--quiet is user-defined
alias gdfm='git fetch && gdf $(git merge-base HEAD origin/master) origin/master'
alias gds="git diff --staged"
alias gdsq="git--quiet diff --staged"  # git--quiet is user-defined
alias gf="git fetch"
alias gl="git --no-pager log --graph --oneline -n 20"
alias glp="git log --patch -n 1"
alias glpq="git--quiet log --patch -n 1"  # git--quiet is user-defined
alias gls="git log -S"
alias gp="git push"
alias gr="git reset HEAD"
alias grc="git rebase --continue"
alias grb="git rebase"
alias grba="git rebase --autosquash"
alias grbai="git rebase --autosquash -i"
alias grbi="git rebase -i"
alias gs="git status -sb"
alias gso="git show"
alias gt="gotestsum -- --count 1 --tags integration --race"
alias gta="gotestsum -- --count 1 --tags integration --race ./..."
alias gtac="gotestsum -- ./..."
alias gu="git pull"
alias gum="git fetch --all && git rebase origin/master"
alias l="ls -1A"
alias ll="ls -lhFA"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cdf='cd "$(finder-pwd)"'  # finder-pwd is user-defined

# Functions

function bat() { command bat --paging=never "$@" }
function grep() { command grep --color=auto "$@" }
function ls() { command ls --color=auto "$@" }

# FIXME: If file doesn't end with a newline, the last variable is not exported.
# Load a .env file (formatted according to the Compose spec)
dotenv() {
    local kv
    cat "${1-.env}" | sed '/^#.*$/d' | sed '/^$/d' | sed -n '/^.*=.*$/p' | while read -r kv; do
        export "$kv"
    done
}

# venv [<path>] activates a Python venv.
venv() {
    local venv="$1"
    if [[ -z "$venv" ]]; then
        venv=".venv"
    fi
    if [[ ! -e "$venv" ]]; then
        echo >&2 "error: venv doesn't exist: $venv"
        return 1
    fi
    venv="$(CDPATH= cd -- "$(dirname -- "$venv")" && pwd)/$(basename -- "$venv")"
    [[ "$?" -ne 0 ]] && return 1

    source "$venv/bin/activate"
}

# mkvenv <version> [<path>] creates a Python venv.
mkvenv() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo >&2 "error: version is not specified"
        return 1
    fi

    local venv="$2"
    if [[ -z "$venv" ]]; then
        venv=".venv"
    fi
    if [[ -e "$venv" ]]; then
        echo >&2 "error: venv already exists"
        return 1
    fi
    venv="$(CDPATH= cd -- "$(dirname -- "$venv")" && pwd)/$(basename -- "$venv")"
    [[ "$?" -ne 0 ]] && return 1

    mise x "python@$version" -- python -m venv "$venv"
    [[ "$?" -ne 0 ]] && return 1

    source "$venv/bin/activate"
}

# rmvenv [<path>] deactivates and removes a Python venv.
rmvenv() {
    local venv="$1"
    if [[ -z "$venv" ]]; then
        venv=".venv"
    fi
    if [[ ! -e "$venv" ]]; then
        echo >&2 "error: venv doesn't exist: $venv"
        return 1
    fi
    venv="$(CDPATH= cd -- "$(dirname -- "$venv")" && pwd)/$(basename -- "$venv")"
    [[ "$?" -ne 0 ]] && return 1

    if [[ "$VIRTUAL_ENV" -ef "$venv" ]]; then
        deactivate
        [[ "$?" -ne 0 ]] && return 1
    fi

    rm -rf "$venv"
}

# Quickly jump into a repository
REPOSITORIES="$HOME/Repositories"
repo() {
    cd "$REPOSITORIES/$1"
}
_repo() {
	_files -/ -W "$REPOSITORIES"
}
compdef _repo repo

# Quickly jump into a note
note() {
    cd "$NOTES/$1"
}

# Compile completion cache from scratch
recompinit() {
    rm "$ZCOMPDUMP"
    compinit -d "$ZCOMPDUMP"
}

#
# From older zshrc
#

# Zsh

# FPATH="$XDG_CONFIG_HOME/zsh/completions:$FPATH"
# PROMPT_EOL_MARK=""
# PS2="%B…%b "
# HISTFILE="$XDG_DATA_HOME/zsh/.zhistory"
# HISTSIZE=10000
# SAVEHIST=10000
# KEYTIMEOUT=1

# ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"  # User-defined
# PROMPT_STYLE="regular"                      # User-defined

# My utils

# export WORKSPACES="$HOME/Workspaces"
# export NOTES="$HOME/Notes"
# export DOTFILES_ENVIRONMENT_LOADED=1

# # Improve global completion
#
# zstyle ':completion:*' menu select
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
# zstyle ':completion:*' use-cache on
# # zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# zstyle ':completion:*' insert-tab pending
# zstyle ':completion:*' single-ignored show
#
# # Denoise completion for ssh, scp and rsync
#
# zstyle -e ':completion:*:hosts' hosts 'reply=(${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ } ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*} ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})'
# zstyle ':completion:*:users' ignored-patterns adm amanda apache avahi beaglidx bin cacti canna clamav daemon dbus distcache dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust ldap lp mail mailman mailnull mldonkey mysql nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
# zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
# zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
# zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
# zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# # Completion
#
# setopt ALWAYS_TO_END           # Move cursor to the end of a completed word
# setopt COMPLETE_IN_WORD        # Allow completion from inside a word
# setopt GLOB_COMPLETE           # Generate completions with globs
# unsetopt LIST_BEEP             # Suppress beep on an ambiguous completion
#

# History

setopt EXTENDED_HISTORY        # Save each command's timestamp in history
unsetopt HIST_BEEP             # Suppress beep on non-existent history access
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate events from history first
setopt HIST_IGNORE_DUPS        # Do not record a just recorded event again
setopt HIST_IGNORE_SPACE       # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS       # Do not save duplicate events in history
setopt SHARE_HISTORY           # Share history between all sessions

# # Input/output
#
# unsetopt FLOW_CONTROL          # Make '^S' and '^Q' key bindings available
# setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shells
