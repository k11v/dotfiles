#
# Built-in
#


# completion: colors
export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# ls: colors
export LSCOLORS='ExfxcxdxbxGxDxabagacad'
export CLICOLOR=1

# grep: colors
export GREP_COLOR='1;33'
alias grep='grep --color=auto'

# less: default options, colors
export LESS="\
--RAW-CONTROL-CHARS \
--chop-long-lines \
--tilde \
--shift=10 \
--ignore-case \
--LONG-PROMPT \
--tabs=4"

# man: colors
export LESS_TERMCAP_mb=$'\e[1;38;5;179m' # begin bold
export LESS_TERMCAP_md=$'\e[1;38;5;179m' # begin blink -> headings & options
export LESS_TERMCAP_so=$'\e[1;38;5;246m' # begin standout-mode -> info box below
export LESS_TERMCAP_us=$'\e[4;38;5;227m' # begin underline -> arguments
export LESS_TERMCAP_me=$'\e[0m' # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m' # reset standout-mode
export LESS_TERMCAP_ue=$'\e[0m' # reset underline


#
# External
#


# ncdu: default options
alias ncdu='ncdu --color dark -rr -x'

# fzf: path update, auto-completions, key bindings
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
