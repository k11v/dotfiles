#
# Sources
#


# Source a file if it exists
include () {
    [[ -f "$1" ]] && source "$1"
}

# Include sources (order matters)
include $ZDOTDIR/exports.zsh # declare constants
include $ZDOTDIR/plugins.zsh # load plugins
include $ZDOTDIR/decorators.zsh # decorate commands
include $ZDOTDIR/aliases.zsh # abbreviate commands
include $ZDOTDIR/functions.zsh # declare functions
include $ZDOTDIR/config.zsh # configure Zsh, PATH and external programs
include $ZDOTDIR/prompt.zsh # configure prompt

# Clean up
unset include
