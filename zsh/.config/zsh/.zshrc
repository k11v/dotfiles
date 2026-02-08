FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
PATH="/opt/homebrew/bin:$PATH"
PATH="/opt/homebrew/sbin:$PATH"

zstyle ":completion:*" cache-path "$ZCOMPCACHE"

autoload -Uz compinit
if [[ "$ZCOMPDUMP"(N.mh-24) ]]; then
	compinit -C -d "$ZCOMPDUMP" # reuse dump
else
	compinit -d "$ZCOMPDUMP" # rebuild dump
	touch "$ZCOMPDUMP"
fi;
