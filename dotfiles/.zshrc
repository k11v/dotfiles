# NO STRUCTURE IS THE BEST STRUCTURE
#                (subject to change)
# ----------------------------------


#
# Variables
#


# --- Directories

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# The directory for repositories
export REPOSITORIES="$HOME/Repositories"

# The directory for pyenv to place Python versions and shims in
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# --- Path

export PATH="$HOME/.local/bin:$PATH"

# Pyenv shims should be before Python executables
export PATH="$PYENV_ROOT/shims:$PATH"

fpath+=( "$XDG_CONFIG_HOME/zsh/completions" )

# --- Colors

# Colors for list command and completions
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'
# Colors for grep command
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

# Colors for less command used in manuals
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# --- Default options

# Options for less command:
# - Make search highlight only current match (-g)
# - Make search match case-insensitive for lowercase (-i)
# - Show viewport's line numbers in the prompt (-M)
# - Render escaped ANSI colors (-R)
# - Chop long lines instead of folding them (-S)
# - Set tab size to 4 (-x4)
export LESS='-g -i -M -R -S -x4'

# --- History

# Path to history file
HISTFILE="$XDG_DATA_HOME/zsh/.zhistory"
# Maximum number of events to save in internal history
HISTSIZE=10000
# Maximum number of events to save in history file
SAVEHIST=10000

# --- Session

# Tell programs that our terminal supports colors
export TERM='xterm-256color'

# Use vim as editor and less as pager
export EDITOR='vim'
export PAGER='less'

# Prefer US English and use UTF-8
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# --- Prompt

# Disable prompt mangling in venv's bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
# Prevent percent sign from showing up if output doesn't end with a newline
PROMPT_EOL_MARK=''
# Use ellipsis as the continuation prompt
PS2='%B…%b '

# --- Completions

# Zsh completion cache
ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"


#
# Mkdirs
#


# Needed for completions
mkdir -p "$XDG_CACHE_HOME/zsh"
# Needed for history
mkdir -p "$XDG_DATA_HOME/zsh"


#
# Zsh options
#


# --- Completions

# Always move cursor to the end of completed word
setopt ALWAYS_TO_END
# Enable completions like 'Mafile' into 'Makefile'
setopt COMPLETE_IN_WORD
# Show completions with unambiguous prefix insertion
unsetopt LIST_AMBIGUOUS
# Don't beep on ambiguous completion
unsetopt LIST_BEEP

# --- History

# Save each command's timestamp in history
setopt EXTENDED_HISTORY
# Don't beep when trying to access a history entry which isn't there
unsetopt HIST_BEEP
# Expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record an entry that was just recorded again
setopt HIST_IGNORE_DUPS
# Don't record an entry starting with space
setopt HIST_IGNORE_SPACE
# Don't write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS
# Immediately update history and share it between all sessions
setopt SHARE_HISTORY

# --- Input/output

# Make globs case-insensitive (cuz it makes Git's completions case-insensitive)
unsetopt CASE_GLOB
# Make unmatched globs resolve to an empty string instead of reporting an error
setopt NULL_GLOB
# Don't allow '>' redirection to override existing files, use '>!' instead
unsetopt CLOBBER
# Allow '>>' redirection to create new files
setopt APPEND_CREATE
# Disable flow control characters to make available '^S' and '^Q' key bindings
unsetopt FLOW_CONTROL
# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS


#
# Zsh styles
#


# --- Completions

# Enable arrow controls for completion and highlight selection
zstyle ':completion:*' menu select
# Colorize file completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Make completion match case-insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
# Prevent pasting with tabs from performing completion
zstyle ':completion:*' insert-tab pending
# Speed up completion for some programs by enabling cache for them
zstyle ':completion:*' use-cache on
# Specify completion cache directory for programs to use
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"


#
# Zsh key bindings
#


# Set emacs key bindings
bindkey -e


#
# Zsh inits
#


# --- Completions

# Initialize completion from cache and regenerate it once a day if needed
autoload -Uz compinit
if [ "$ZCOMPDUMP"(N.mh-24) ]; then
    # Cache is still fresh therefore don't regenerate it
    compinit -C -d "$ZCOMPDUMP"
else
    # Cache is older than 24 hours, regenerate it if needed
    compinit -d "$ZCOMPDUMP"
    # Update cache's timestamp if it didn't need regeneration
    touch "$ZCOMPDUMP"
fi;

# --- Prompt

_dotfiles_prompt_precmd() {
    local exit_status="$?"

    local username=''
    local hostname=''
    local workdir='%B%F{cyan}%~%f%b'
    local branch=''
    local venv=''
    local symbol='%B%F{green}❯%f%b'

    # Show username and hostname when connected via SSH
    if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
        username='%B%F{yellow}%n%f%b in '
        hostname='%B%F{green}%m%f%b in '
    fi

    # Show red username for superuser
    if [[ "${EUID-}" -eq 0 ]]; then
        username='%B%F{red}%n%f%b in '
    fi

    # Show branch when in a Git repository
    local ref ref_status
    ref="$(command git symbolic-ref --quiet HEAD 2> /dev/null)"
    ref_status="$?"
    if [[ "$ref_status" -eq 128 ]]; then
        # No Git repository here
    elif [[ "$ref_status" -eq 0 ]]; then
        # Ref variable contains the current branch
        branch=" on %B%F{magenta}${ref#refs/heads/}%f%b"
    elif ref="$(command git rev-parse --short HEAD 2> /dev/null)"; then
        # HEAD is in a detached state
        branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($ref)%b%f"
    fi

    # Show venv when it's activated
    if [[ -n "${VIRTUAL_ENV-}" ]]; then
        venv=" via %B%F{yellow}${VIRTUAL_ENV:t}%f%b"
    fi

    # Color symbol red if previous command failed
    if [[ "$exit_status" -ne 0 ]]; then
        symbol='%B%F{red}❯%f%b'
    fi

    PROMPT=$'\n'"$username$hostname$workdir$branch$venv"$'\n'"$symbol "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_prompt_precmd

# --- Programs

# Enable fzf features configured during setup
source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

# Lazy init pyenv either through the command or through the completion
_dotfiles_pyenv_init() {
    # The second run of this function will be harmful to the environment
    unfunction _dotfiles_pyenv_init

    # Remove lazy functions and completers in favor of whatever the init brings
    unfunction pyenv
    unfunction _pyenv
    compdef -d pyenv

    # Initialize pyenv to get new 'pyenv' function and completions
    eval "$(pyenv init -)"
}
pyenv() {
    # Intercept pyenv call to perform initialization
    _dotfiles_pyenv_init

    # Perform the real pyenv call after initialization
    pyenv "$@"

}
_pyenv() {
    # Intercept pyenv completion to perform initialization
    _dotfiles_pyenv_init

    # Perform the real pyenv completion after initialization
    _main_complete
}
compdef _pyenv pyenv


#
# Aliases
#


# Enable aliases to be sudo'ed
alias sudo="sudo "

# --- Default options

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- Abbreviations

alias l='ls -1A'
alias ll='ls -lFA'

alias c='clear'

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git --no-pager log --graph --oneline -n 20'
alias gp='git push'
alias gr='git reset HEAD'
alias gs='git status -sb'
alias gu='git pull'


#
# Functions
#


# Change working directory to the top-most Finder window location
cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Reload the shell (i.e. invoke as a login shell)
reload() {
    clear && exec "$SHELL" -l
}

# Compile completion cache from scratch
recompinit() {
    rm "$ZCOMPDUMP"
    compinit -d "$ZCOMPDUMP"
}

# Compare files using Git's colored diff
diff() {
    git diff --no-index "$@"
}

# Get external IP
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}
