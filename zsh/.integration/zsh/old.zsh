export PATH="$PATH:/opt/homebrew/opt/git/bin" # use newer Git from Homebrew
export PATH="$PATH:$HOME/.local/dist/nvim/bin"

export CARGO_HOME="$HOME/.local/share/cargo"
export PATH="$PATH:$HOME/.local/share/cargo/bin"
export RUSTUP_HOME="$HOME/.local/share/rustup"

export PAGER="less"
export LESS="-g -i -M -R -S -x4 --mouse --wheel-lines=5"

# Input

# Use Vim line editor.
bindkey -v

# Don't wait for more input when <Esc> is inputted.
KEYTIMEOUT=1

# Change default cursor.
function _cursor_precmd() {
   printf "\e[6 q" # beam
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _cursor_precmd

# Change cursor when Vim line editor mode changes.
function zle-keymap-select() {
    if [[ "$KEYMAP" == "main" ]]; then
        printf "\e[6 q" # beam
    elif [[ "$KEYMAP" == "vicmd" ]]; then
        printf "\e[2 q" # block
    fi
}
zle -N zle-keymap-select

# History

# HISTFILE="$HOME/.local/share/zsh/.zhistory" # set in the main .zshrc
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY # Save each command's timestamp in history

# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
function _search_history() {
    local selected num ret
    # '--no-clear-start' fixes https://github.com/lotabout/skim/issues/494
    selected="$(fc -lr 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --no-clear-start --height 40% -n2..,.. --tiebreak=index --query "$BUFFER")"
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
bindkey -M emacs "^R" _search_history
bindkey -M vicmd "^R" _search_history
bindkey -M viins "^R" _search_history

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
alias gc="git_commit"  # git_commit is user-defined
alias gcf="git commit --fixup"
alias gca="git commit --amend"
alias gci='git commit --allow-empty -m "Initial commit"'
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gcu='git reset --soft HEAD~1'  # [U]ndo the last [c]ommit
alias gcw='git commit -m "wip"'
alias gd="git diff"
alias gdfm='git fetch && gdf $(git merge-base HEAD origin/master) origin/master'
alias gds="git diff --staged"
alias gf="git fetch"
alias gl="git --no-pager log --graph --oneline -n 20"
alias glp="git log --patch -n 1"
alias gls="git log -S"
alias gp="git push"
alias gr="git reset HEAD"
alias grc="git rebase --continue"
alias grb="git rebase"
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

# Functions

function cdf () {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

function jsonfromcsv() {
	python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))'
}

function gdf() {
	local preview="git diff $@ -- {} | delta"
	git diff --name-only "$@" | fzf --preview "$preview"
}

function git-clone() {
    local repository="$1"
    if [[ -z "$repository" ]]; then
        echo "error: empty repository (arg 1)" >&2
        return 1
    fi

    local directory="$2"
    if [[ -z "$directory" ]]; then
        echo "error: empty directory (arg 2)" >&2
        return 1
    fi

    (
        set -e
        mkdir -p -- "$directory"
        cd -- "$directory"
        git init --bare .git
        git remote add origin -- "$repository"
        git fetch origin

        if git rev-parse --verify origin/main &> /dev/null; then
            git worktree add -b main -- "$(basename -- "$(pwd)")@main" origin/main
        elif git rev-parse --verify origin/master &> /dev/null; then
            git worktree add -b master -- "$(basename -- "$(pwd)")@master" origin/master
        fi
    )
}

function gdfb() {
	local branch="$1"
	if [[ -z "$branch" ]]; then
		echo "error: empty branch" >&2
		return 1
	fi
	git fetch && gdf $(git merge-base "$branch" origin/master) "$branch"
}

function gdfbo() {
	local branch="$1"
	if [[ -z "$branch" ]]; then
		echo "error: empty branch" >&2
		return 1
	fi
	gdf $(git merge-base "$branch" origin/master) "$branch"
}

function gcfa() {
	git commit --fixup "$1"
	git rebase --autosquash "$1"^
}

function git_commit() {
    local args=()
    local message_option_key=""
    local message_option_value=""

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -m)
                message_option_key="$1"
                message_option_value="$2"
                shift 2
                ;;
            *)
                args+=("$1")
                shift
                ;;
        esac
    done

    local ticket=""
    local branch="$(git rev-parse --abbrev-ref HEAD)"
    local matches=""

    if [[ "$branch" =~ ^(main|master|(feature/[A-Za-z0-9-]+)|(fix/[A-Za-z0-9-]+))$ ]]; then
	    ticket=""
    elif [[ "$branch" =~ ^([A-Z]+-[0-9]+)[A-Za-z0-9-]*$ ]]; then
	    ticket="${match[1]}"
    else
	    echo "error: unknown branch pattern" >&2
	    return 1
    fi

    if [[ -z "$ticket" ]]; then
        message_option_value="$message_option_value"
    else
        message_option_value="$ticket $message_option_value"
    fi

    if [[ -z "$message_option_key" ]]; then
        git commit "${args[@]}"
    else
        git commit "$message_option_key" "$message_option_value" "${args[@]}"
    fi
}

function dataurl() {
    if [ -z "$1" ]; then
        echo "Usage: dataurl <file>" >&2
        exit 2
    fi
    mimetype="$(file -bN --mime-type "$1")"
    content="$(base64 < "$1")"
    echo "data:$mimetype;base64,$content"
}

function uuid4() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

function printcolors() {
    printf "%s %s%s%s %s%s%s %s%s%s\n" \
        " " ""                "NORMAL " ""             "$(tput bold)"                "BOLD NORMAL " "$(tput sgr0)" ""                "BACKGROUND NORMAL " ""             \
        "0" "$(tput setaf 0)" "BLACK  " "$(tput sgr0)" "$(tput bold)$(tput setaf 0)" "BOLD BLACK  " "$(tput sgr0)" "$(tput setab 0)" "BACKGROUND BLACK  " "$(tput sgr0)" \
        "1" "$(tput setaf 1)" "RED    " "$(tput sgr0)" "$(tput bold)$(tput setaf 1)" "BOLD RED    " "$(tput sgr0)" "$(tput setab 1)" "BACKGROUND RED    " "$(tput sgr0)" \
        "2" "$(tput setaf 2)" "GREEN  " "$(tput sgr0)" "$(tput bold)$(tput setaf 2)" "BOLD GREEN  " "$(tput sgr0)" "$(tput setab 2)" "BACKGROUND GREEN  " "$(tput sgr0)" \
        "3" "$(tput setaf 3)" "YELLOW " "$(tput sgr0)" "$(tput bold)$(tput setaf 3)" "BOLD YELLOW " "$(tput sgr0)" "$(tput setab 3)" "BACKGROUND YELLOW " "$(tput sgr0)" \
        "4" "$(tput setaf 4)" "BLUE   " "$(tput sgr0)" "$(tput bold)$(tput setaf 4)" "BOLD BLUE   " "$(tput sgr0)" "$(tput setab 4)" "BACKGROUND BLUE   " "$(tput sgr0)" \
        "5" "$(tput setaf 5)" "MAGENTA" "$(tput sgr0)" "$(tput bold)$(tput setaf 5)" "BOLD MAGENTA" "$(tput sgr0)" "$(tput setab 5)" "BACKGROUND MAGENTA" "$(tput sgr0)" \
        "6" "$(tput setaf 6)" "CYAN   " "$(tput sgr0)" "$(tput bold)$(tput setaf 6)" "BOLD CYAN   " "$(tput sgr0)" "$(tput setab 6)" "BACKGROUND CYAN   " "$(tput sgr0)" \
        "7" "$(tput setaf 7)" "WHITE  " "$(tput sgr0)" "$(tput bold)$(tput setaf 7)" "BOLD WHITE  " "$(tput sgr0)" "$(tput setab 7)" "BACKGROUND WHITE  " "$(tput sgr0)"
}

# httpdump dumps HTTP traffic on the loopback interface with given TCP port.
# You can use it by starting an HTTP server locally and httpcapture with its port,
# then making HTTP requests to it using cURL, web browser or other tool.
# It outputs in a format simular to Wireshark's "follow TCP stream" except it is live.
# TODO: check for a case when HTTP messages are broken into multiple TCP datagrams.
function httpdump() {
    local server_port="8000"
    if [[ -n "$1" ]]; then
        server_port="$1"
    fi

    # tshark: captures packets on an interface
    #   -i lo0: listens to the loopback interface, 127.0.0.1 is there
    #   -Y "http && tcp.port == $server_port": filters HTTP messages, filters $server_port TCP port
    #   -T ek: outputs in ElasticSearch format which produces two newline-delimited JSONs per message, one with meta, another with data
    #   -e tcp.payload: includes just the hex-encoded tcp.payload in data
    #   -q: don't output message count when piping tshark
    #   -l: don't buffer tshark output when piping
    # jq: transform HTTP messages from tshark format to their raw hex data
    #   -r: output raw strings that we select later (i.e. without double quotes)
    #  --unbuffered: don't buffer jq output when piping
    #  'select(has("timestamp")) | .layers.tcp_payload[]': filter data JSONs (exclude meta JSONs), then select tcp_payloads (TODO: in the future we might need to join tcp_payload if output is malformed when multiple TCP datagrams are used per HTTP message)
    # xxd -r -p: convert hex to plain text
    tshark -i lo0 -Y "http && tcp.port == $server_port" -T ek -e tcp.payload -q -l \
    | jq -r --unbuffered 'select(has("timestamp")) | .layers.tcp_payload[]' \
    | while IFS= read -r line; do
        if [[ "$line" == 48545450* ]]; then
            # If line starts with 48545450 ("48545450" is hex for "HTTP"), output blue (responses start with "HTTP/1.1")
            printf "%s%s%s\n\n" "$(tput setaf 4)" "$(echo "$line" | xxd -r -p)" "$(tput sgr0)"
        else
            # Otherwise, output red (requests start with method name)
            printf "%s%s%s\n\n" "$(tput setaf 1)" "$(echo "$line" | xxd -r -p)" "$(tput sgr0)"
        fi
    done
}

function gbl() {
	ls -1 .git/refs/heads | fzf -m --preview "git log --patch -n 10 {} | delta"
}

function grw() {
	GIT_SEQUENCE_EDITOR="$(cat <<'EOF'
/bin/sh -c '
    temp="$(mktemp)"
    sed "1s/^pick /reword /" < "$1" > "$temp"
    cat < "$temp" > "$1"
    rm -f -- "$temp"
' /bin/sh
EOF
	)" git rebase -i "$1^"
}

function myip() {
    ifconfig | grep inet | grep -v inet6 | cut -d " " -f 2
}
