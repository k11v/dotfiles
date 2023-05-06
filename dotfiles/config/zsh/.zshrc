source "$ZDOTDIR/variables.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

for init in "$ZDOTDIR/inits/"*.zsh; do
    source "$init"
done

unset init
