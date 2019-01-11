# ---------------------------------------------------------------------------- #
# Directories
# ---------------------------------------------------------------------------- #


# the maximum size of the directory stack for `pushd` and `popd`
export DIRSTACKSIZE='9'

# make cd push the old directory onto the directory stack
setopt AUTO_PUSHD


# ---------------------------------------------------------------------------- #
# Completion
# ---------------------------------------------------------------------------- #


# use caching to make completion faster
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

# use completion menu for completion when available
zstyle ':completion:*' menu select
# case-insensitive, partial-word and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# don't perform completion when pasting with tabs
zstyle ':completion:*' insert-tab pending

# move cursor to the end of a completed word
setopt ALWAYS_TO_END
# automatically list choices on ambiguous completion
setopt AUTO_LIST 
# show completion menu on a succesive tab press
setopt AUTO_MENU
# if completed parameter is a directory, add a trailing slash
setopt AUTO_PARAM_SLASH
# complete from both ends of a word
setopt COMPLETE_IN_WORD
# don't insert anything resulting from a glob pattern, show completion menu
setopt GLOB_COMPLETE
# don't beep on an ambiguous completion
setopt NO_LIST_BEEP


# ---------------------------------------------------------------------------- #
# History
# ---------------------------------------------------------------------------- #


# where history logs are stored
export HISTFILE=$ZSH_CACHE_DIR/.zhistory
# the maximum number of history events to save in the history file
export SAVEHIST='32768'
# the maximum number of events stored in the internal history list
export HISTSIZE='32768'

# save each command's epoch timestamps and the duration in seconds
setopt EXTENDED_HISTORY
# expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# don't record an entry that was just recorded again
setopt HIST_IGNORE_DUPS
# don't record an entry starting with a space
setopt HIST_IGNORE_SPACE
# don't write duplicate entries in the history file
setopt HIST_SAVE_NO_DUPS
# write to the history file immediately, not when the shell exits
setopt INC_APPEND_HISTORY
# share history between all sessions
setopt SHARE_HISTORY


# ---------------------------------------------------------------------------- #
# Input/Output
# ---------------------------------------------------------------------------- #


# don't allow `>` redirection to override existing files; use `>!` instead
setopt NO_CLOBBER
# disable flow control characters `^S` and `^Q`
setopt NO_FLOW_CONTROL
# disable ^D to logout and exit on end-of-file
setopt IGNORE_EOF
# allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS
# enable "anything but" globs
setopt EXTENDED_GLOB
# run the command removing glob from the argument list if nothing matched
setopt NULL_GLOB


# ---------------------------------------------------------------------------- #
# Key bindings
# ---------------------------------------------------------------------------- #


# set emacs mode
bindkey -e
# previously `esc+B`
bindkey '^B' backward-word
# previously `esc+F`
bindkey '^F' forward-word
