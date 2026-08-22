HISTFILE="$HOME/.local/share/zsh/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
[[ ! -e "$HOME/.local/share/zsh" ]] && mkdir -p "$HOME/.local/share/zsh"

setopt EXTENDED_HISTORY       # save each command's timestamp in history
unsetopt HIST_BEEP            # suppress beep on non-existent history access
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate events from history first
setopt HIST_IGNORE_DUPS       # do not record a just recorded event again
setopt HIST_IGNORE_SPACE      # do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS      # do not save duplicate events in history
setopt SHARE_HISTORY          # share history between all sessions

# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
function _search_history() {
    local selected num ret
    # '--no-clear-start' fixes https://github.com/lotabout/skim/issues/494
    selected="$(fc -lr 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' | sk --exact --no-sort --no-clear-start --height 40% -n2.. --query "$BUFFER")"
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
bindkey "^R" _search_history
