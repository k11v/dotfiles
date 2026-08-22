FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
ZCOMPCACHE="$HOME/.cache/zsh/.zcompcache" # user-defined
ZCOMPDUMP="$HOME/.cache/zsh/.zcompdump"   # user-defined
autoload -Uz compinit
[[ ! -e "$HOME/.cache/zsh" ]] && mkdir -p "$HOME/.cache/zsh"
[[ "$ZCOMPDUMP"(N.mh-24) ]] && compinit -C -d "$ZCOMPDUMP" || { compinit -d "$ZCOMPDUMP"; touch "$ZCOMPDUMP" }

zstyle ':completion:*' cache-path "$ZCOMPCACHE"
zstyle ':completion:*' use-cache on

setopt GLOB_COMPLETE # generate completions with globs
unsetopt LIST_BEEP   # suppress beep on an ambiguous completion
