source "$HOME/.config/zsh/variables.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

source "$HOME/.config/zsh/inits/zsh-bindings.zsh"
source "$HOME/.config/zsh/inits/zsh-completion.zsh"
source "$HOME/.config/zsh/inits/zsh-options.zsh"
source "$HOME/.config/zsh/inits/zsh-prompt.zsh"

source "$HOME/.config/zsh/inits/fzf.zsh"
source "$HOME/.config/zsh/inits/pyenv.zsh"
