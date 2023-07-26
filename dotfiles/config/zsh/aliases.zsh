# Global

alias sudo="sudo "  # Enable aliases to be sudo'ed

# macOS utils

alias o="open"

# Terminal utils

alias c="clear"

# Editor

alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# GNU utils

alias ls="ls --color=auto"
alias grep="grep --color=auto"

alias l="ls -1A --group-directories-first"
alias ll="ls -lhFA --group-directories-first"

# Other utils

alias iconv-windows-1251-to-utf-8="iconv -f WINDOWS-1251 -t UTF-8"

# Git

alias ga="git add"
alias gap="git add --patch"
alias gb="git branch"
alias gc="git commit"
alias gca="git commit --amend"
alias gci='git commit --allow-empty -m "Initial commit"'
alias gcw='git commit -m "wip"'
alias gcu='git reset --soft HEAD~1'  # [U]ndo the last [c]ommit
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gl="git --no-pager log --graph --oneline -n 20"
alias glp="git log --patch -n 1"
alias gp="git push"
alias gr="git reset HEAD"
alias gs="git status -sb"
alias gu="git pull"

# Docker

alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up"
alias dcud="docker compose up -d"
alias dcd="docker compose down"
alias dcdv="docker compose down -v"
alias dcl="docker compose logs"
