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

#
# From older zshrc
#

# Zsh

# KEYTIMEOUT=1
# PROMPT_STYLE="regular"                      # User-defined

# My utils

# export WORKSPACES="$HOME/Workspaces"
# export NOTES="$HOME/Notes"
# export DOTFILES_ENVIRONMENT_LOADED=1

# # Input/output
#
# unsetopt FLOW_CONTROL          # Make '^S' and '^Q' key bindings available
# setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shells
