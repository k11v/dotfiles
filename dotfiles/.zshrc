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
# Zsh configuration
#


# --- Completions

# Always move cursor to the end of completed word
setopt ALWAYS_TO_END
# Enable completions like "Mafile" -> "Makefile"
setopt COMPLETE_IN_WORD
# Show completions with unambiguous prefix insertion
unsetopt LIST_AMBIGUOUS

# --- Expansion and globbing

# Make unmatched globs resolve to an empty string instead of reporting an error
setopt NULL_GLOB
