# Directories

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# The directory for repositories
export REPOSITORIES="$HOME/Repositories"

# The directory for pyenv to place Python versions and shims in
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# Path

# XDG executables
export PATH="$HOME/.local/bin:$PATH"

# Pyenv shims should be before Python executables
export PATH="$PYENV_ROOT/shims:$PATH"

export FPATH="$XDG_CONFIG_HOME/zsh/completions:$FPATH"

# Colors

# Colors for list command and completions
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'
# Colors for grep command
export GREP_COLORS='ms=01;31:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'

# Colors for less command used in manuals
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# Default options

# Options for less command:
# - Make search highlight only current match (-g)
# - Make search match case-insensitive for lowercase (-i)
# - Show viewport's line numbers in the prompt (-M)
# - Render escaped ANSI colors (-R)
# - Chop long lines instead of folding them (-S)
# - Set tab size to 4 (-x4)
export LESS='-g -i -M -R -S -x4'

# Session

# Tell programs that our terminal supports colors
export TERM='xterm-256color'

# Set editors to vim and pager to less
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Prefer US English and use UTF-8
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Prompt

# Disable prompt mangling caused by activating Python virtualenvs
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Prevent percent sign from showing up if output doesn't end with a newline
PROMPT_EOL_MARK=''
# Use ellipsis as the continuation prompt
PS2='%B…%b '

# History

# Path to history file
HISTFILE="$XDG_DATA_HOME/zsh/.zhistory"
# Maximum number of events to save in internal history
HISTSIZE=10000
# Maximum number of events to save in history file
SAVEHIST=10000

# Completion

ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"
