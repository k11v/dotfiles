#
# Directories
#


# The maximum size of the directory stack for 'pushd' and 'popd'
export DIRSTACKSIZE='9'

# Make 'cd' push the old directory onto the directory stack
setopt AUTO_PUSHD


#
# Completion
#


# Use caching to make completion faster
ZCOMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
autoload -Uz compinit
if [[ -n $ZCOMPDUMP(#qN.mh+24) ]]; then
  compinit -i -d $ZCOMPDUMP
else
  compinit -C -i -d $ZCOMPDUMP
fi
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR"
unset ZCOMPDUMP

# Use completion menu for completion when available
zstyle ':completion:*' menu select
# Make completion case-insensitive, partial-word and substring
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Don't perform completion when pasting with tabs
zstyle ':completion:*' insert-tab pending

# Move cursor to the end of completed word
setopt ALWAYS_TO_END
# Automatically list choices on ambiguous completion
setopt AUTO_LIST 
# Show completion menu on succesive tab press
setopt AUTO_MENU
# If completed parameter is a directory, add a trailing slash
setopt AUTO_PARAM_SLASH
# Complete from both ends of word
setopt COMPLETE_IN_WORD
# Don't insert anything resulting from glob pattern, show completion menu
setopt GLOB_COMPLETE
# Don't beep on ambiguous completion
setopt NO_LIST_BEEP


#
# History
#


# Where history logs are stored
export HISTFILE=$ZSH_CACHE_DIR/.zhistory
# The maximum number of history events to save in the history file
export SAVEHIST='32768'
# The maximum number of events stored in the internal history list
export HISTSIZE='32768'

# Save each command's epoch timestamps and the duration in seconds
setopt EXTENDED_HISTORY
# Expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record an entry that was just recorded again
setopt HIST_IGNORE_DUPS
# Don't record an entry starting with space
setopt HIST_IGNORE_SPACE
# Don't write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS
# Write to the history file immediately, not when the shell exits
setopt INC_APPEND_HISTORY
# Share history between all sessions
setopt SHARE_HISTORY


#
# Input/Output
#


# Don't allow '>' redirection to override existing files; use '>!' instead
setopt NO_CLOBBER
# Disable flow control characters '^S' and '^Q'
setopt NO_FLOW_CONTROL
# Allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS
# Enable "anything but" globs
setopt EXTENDED_GLOB
# Run the command removing glob from the argument list if nothing matched
setopt NULL_GLOB


#
# Key bindings
#


# Set Emacs mode
bindkey -e


#
# External commands initialization
#


# pyenv (modifies PATH)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
