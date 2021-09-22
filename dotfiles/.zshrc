source "${0:h}/zsh/variables.zsh"

mkdir -p "$XDG_CACHE_HOME/zsh"
mkdir -p "$XDG_DATA_HOME/zsh"

source "${0:h}/zsh/aliases.zsh"
source "${0:h}/zsh/functions.zsh"

source "${0:h}/zsh/inits/zsh-bindings.zsh"
source "${0:h}/zsh/inits/zsh-completion.zsh"
source "${0:h}/zsh/inits/zsh-options.zsh"
source "${0:h}/zsh/inits/zsh-prompt.zsh"

source "${0:h}/zsh/inits/fzf.zsh"
source "${0:h}/zsh/inits/pyenv.zsh"
