# NO STRUCTURE IS THE BEST STRUCTURE
#                (subject to change)
# ----------------------------------


#
# Aliases
#


# Enable aliases to be sudo'ed
alias sudo="sudo "

alias l='ls -1A'
alias ll='ls -lFA'

alias c='clear'

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff --staged'
alias gf='git fetch'
alias gl='git log --graph --oneline -n 20'
alias gp='git push'
alias gr='git reset HEAD'
alias gs='git status -sb'
alias gu='git pull'


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
# Zsh completion
#


# -- Compinit

# Initialize completion from cache and update it once a day
ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
autoload -Uz compinit
if [[ -n $ZCOMPDUMP(#qN.mh+24) ]]; then
    compinit -d $ZCOMPDUMP
else
    compinit -C -d $ZCOMPDUMP
fi
unset ZCOMPDUMP

# --- Styles

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
