PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/bin:$PATH"
PATH="/opt/homebrew/sbin:$PATH"

HISTFILE="$HOME/.local/share/zsh/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
[[ ! -e "$HOME/.local/share/zsh" ]] && mkdir -p "$HOME/.local/share/zsh"

FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
ZCOMPCACHE="$HOME/.cache/zsh/.zcompcache" # user-defined
ZCOMPDUMP="$HOME/.cache/zsh/.zcompdump" # user-defined
zstyle ":completion:*" cache-path "$ZCOMPCACHE"
autoload -Uz compinit
[[ ! -e "$HOME/.local/cache/zsh" ]] && mkdir -p "$HOME/.local/cache/zsh"
[[ "$ZCOMPDUMP"(N.mh-24) ]] && compinit -C -d "$ZCOMPDUMP" || { compinit -d "$ZCOMPDUMP"; touch "$ZCOMPDUMP" }

for f in "$HOME"/.local/share/zsh/integration/*.zsh(N); do
	source "$f"
done
