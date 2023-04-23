source "$ZDOTDIR/variables.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

source "$ZDOTDIR/inits/zsh-bindings.zsh"
source "$ZDOTDIR/inits/zsh-completion.zsh"
source "$ZDOTDIR/inits/zsh-options.zsh"
source "$ZDOTDIR/inits/zsh-prompt.zsh"

source "$ZDOTDIR/inits/fzf.zsh"
source "$ZDOTDIR/inits/pyenv.zsh"
source "$ZDOTDIR/inits/poetry.zsh"
source "$ZDOTDIR/inits/suite.zsh"
