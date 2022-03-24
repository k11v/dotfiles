# Use Vim key bindings

bindkey -v

# Change cursor depending on the current Vim mode

zle-keymap-select() {
    if [[ "$KEYMAP" == "vicmd" || "$1" == "block" ]]; then
        echo -ne "\e[2 q"
    elif [[ -z "$KEYMAP" || "$KEYMAP" == "main" || "$KEYMAP" == "viins" || "$1" == "beam" ]]; then
        echo -ne "\e[6 q"
    fi
}
zle -N zle-keymap-select

_cursor_precmd() {
   echo -ne "\e[6 q"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _cursor_precmd
