#
# Sources
#


# sources file if exists
include () {
    [[ -f "$1" ]] && source "$1"
}

# order matters
include $ZDOTDIR/exports.zsh # declare constants
include $ZDOTDIR/plugins.zsh # load plugins
include $ZDOTDIR/decorators.zsh # decorate commands
include $ZDOTDIR/aliases.zsh # abbreviate commands
include $ZDOTDIR/functions.zsh # declare functions
include $ZDOTDIR/config.zsh # configure Zsh settings and PATH
include $ZDOTDIR/prompt.zsh # configure prompt

# clean up
unset include
