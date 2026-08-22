# Default cursor.
function _cursor_precmd() {
   printf "\e[6 q" # beam
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _cursor_precmd

unsetopt FLOW_CONTROL       # make ^S and ^Q key bindings available
setopt INTERACTIVE_COMMENTS # allow comments in interactive shells
