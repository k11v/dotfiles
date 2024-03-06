# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
_search_history() {
    local selected num ret
    # '--no-clear-start' fixes https://github.com/lotabout/skim/issues/494
    selected="$(fc -lr 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --no-clear-start --height 40% -n3.. --tiebreak=index --query "$BUFFER")"
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
