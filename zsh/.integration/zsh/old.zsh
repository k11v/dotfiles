export PATH="$PATH:/opt/homebrew/opt/git/bin" # use newer Git from Homebrew
export PATH="$PATH:$HOME/.local/dist/nvim/bin"

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

function bat() { command bat --paging=never "$@" }
function grep() { command grep --color=auto "$@" }
function ls() { command ls --color=auto "$@" }

function cdf() {
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

myexternalip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# FIXME: If file doesn't end with a newline, the last variable is not exported.
# Load a .env file (formatted according to the Compose spec)
dotenv() {
    local kv
    cat "${1-.env}" | sed '/^#.*$/d' | sed '/^$/d' | sed -n '/^.*=.*$/p' | while read -r kv; do
        export "$kv"
    done
}

dsa() {
    local problem_name subproblem_name main_path repo_root current_dir module_path

    problem_name="$(slugify "$1")"
    subproblem_name="$(slugify "$2")"

    if [[ -z "$problem_name" ]]; then
        echo "error: missing problem name" >&2
        return 1
    fi
    
    if [[ -z "$subproblem_name" ]]; then
        main_path="$problem_name"
    else
        main_path="$problem_name/$subproblem_name"
    fi

    repo_root="$(git rev-parse --show-toplevel)"
    current_dir="$(pwd)"
    if [[ "$current_dir" == "$repo_root" ]]; then
        module_path="github.com/k11v/dsa/$problem_name"
    else
        module_path="github.com/k11v/dsa/${current_dir#$repo_root/}/$problem_name"
    fi

    mkdir -p "$problem_name"
    cat <<EOF > "$problem_name/go.mod"
module $module_path

go 1.23.4
EOF
    cat <<EOF > "$problem_name/README.md"
Time to solve:

- read: 0s
- think: 0s
- implement: 0s
- check and fix: 0s
- run and fix: 0s
- success: 0s
- read: 0s
- solve: 0s
- success: 0s
- _total: 0s_
EOF

    mkdir -p "$main_path"
    cat <<EOF > "$main_path/main.go"
package main

func main() {
}
EOF
}

# awesomestars reads HTML from the standart input, extracts links,
# retrieves stargazer count for each link to a GitHub repository,
# and returns the links enriched with stargazer count.
awesomestars() {
    # Parse Pandoc Link objects from STDIN.
    # cat is actually redundant but it shows intent.
    items="$(cat | pandoc --from html --to json | jq -c '.. | if type == "object" and .t == "Link" then . else empty end' | while read l; do
        # Parse link name and URL into n and u.
        n="$(echo "$l" | jq '.c[1]' | jq '{
          "pandoc-api-version": [1, 23, 1],
          "meta": {},
          "blocks": [
            {
              "t": "Plain",
              "c": .
            }
          ]
        }' | pandoc --from json --to plain)"
        u="$(echo "$l" | jq -r '.c[2][0]')"

        # Parse GitHub repository's owner/name from URL into repo, then fetch star count into s.
        repo="$(echo "$u" | python3 -c '
import sys, urllib.parse
scheme, netloc, path, _, _ = urllib.parse.urlsplit(sys.stdin.readline())
if not (scheme == "http" or scheme == "https"): exit()
if not (netloc == "github.com"): exit()
if not (len(path) > 0): exit()
print(path[1:])
        ')"
        if [[ -n "$repo" ]]; then
            s="$(gh repo view "$repo" --json stargazerCount | jq '.stargazerCount')"
        else
            s="0"
        fi

        # Output name, url, star_count.
        jq -c -n --arg name "$n" --arg url "$u" --arg star_count "$s" '{"name": $name, "url": $url, "star_count": ($star_count | tonumber)}'
        printf '.' >&2 # singal that we processed one URL
    done)"
    printf "\n" >&2

    printf "%s" "$items" | jq -s -c 'sort_by(.star_count) | reverse | .[]'
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

git-log-with-dates() {
    # See:
    # - https://devhints.io/git-log-format
    # - https://www.git-scm.com/docs/git-config#Documentation/git-config.txt-color
    # - https://www.git-scm.com/docs/git-log#_pretty_formats
    git log --pretty='format:%aD %C(bold)%C(yellow)%h%Creset %s'
}

# NOTE: This function creates dangling commits.
git-branch-squash-merged() {
    local branches="$(git branch --format="%(refname:short)")"
    local current_branch="$(git branch --show-current --format="%(refname:short)")"
    local default_branch="main"

    if [[ "$current_branch" != "$default_branch" ]]; then
        echo 1>&2 "Error: You must be on the default branch ('$default_branch') to run this command."
        return 1
    fi

    echo "$branches" | while read -r branch; do
        if [[ "$branch" == "$default_branch" ]]; then
            continue
        fi

        local ancestor_commit="$(git merge-base "$branch" "$default_branch")"
        local branch_tree="$(git rev-parse "$branch^{tree}")"
        local recreated_squash_commit="$(git commit-tree "$branch_tree" -p "$ancestor_commit" -m "Recreated squash commit for '$branch'")"

        if [[ -z "$recreated_squash_commit" ]]; then
            echo >&2 "Error: Failed to recreate squash commit for '$branch'. Skipping."
            continue
        fi

        if [[ $(git cherry "$default_branch" "$recreated_squash_commit") != "-"* ]]; then
            continue
        fi

        echo "$branch"
    done
}

# Compile completion cache from scratch
recompinit() {
    rm "$ZCOMPDUMP"
    compinit -d "$ZCOMPDUMP"
}

# Pipe to browser
bcat() {
    local tempdir="$(mktemp -d)"
    cat > "$tempdir/document.html"
    open "$tempdir/document.html"
    sleep 0.2
    rm -rf -- "$tempdir"
}

# Display the current date in UTC and ISO 8601 format
now() {
    date -u "+%Y-%m-%dT%H:%M:%SZ"
}

# Get website's title
titleof() {
    curl -sSL -o - -- "$1" | perl -l -0777 -n -e 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si'
}

printcolors() {
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

lspypi() {
    curl -fsSL -H "Accept: application/vnd.pypi.simple.v1+json" "https://pypi.org/simple/$1/" | jq --raw-output ".versions[]" | sort --version-sort
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
# # History
#
# setopt EXTENDED_HISTORY        # Save each command's timestamp in history
# unsetopt HIST_BEEP             # Suppress beep on non-existent history access
# setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate events from history first
# setopt HIST_IGNORE_DUPS        # Do not record a just recorded event again
# setopt HIST_IGNORE_SPACE       # Do not record an event starting with a space
# setopt HIST_SAVE_NO_DUPS       # Do not save duplicate events in history
# setopt SHARE_HISTORY           # Share history between all sessions
#
# # Input/output
#
# unsetopt FLOW_CONTROL          # Make '^S' and '^Q' key bindings available
# setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shells
