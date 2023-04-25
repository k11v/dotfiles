# Completion

setopt ALWAYS_TO_END           # Move cursor to the end of a completed word
setopt COMPLETE_IN_WORD        # Allow completion from inside a word
setopt GLOB_COMPLETE           # Generate completions with globs
unsetopt LIST_BEEP             # Suppress beep on an ambiguous completion

# History

setopt EXTENDED_HISTORY        # Save each command's timestamp in history
unsetopt HIST_BEEP             # Suppress beep on non-existent history access
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate events from history first
setopt HIST_IGNORE_DUPS        # Do not record a just recorded event again
setopt HIST_IGNORE_SPACE       # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS       # Do not save duplicate events in history
setopt SHARE_HISTORY           # Share history between all sessions

# Input/output

unsetopt FLOW_CONTROL          # Make '^S' and '^Q' key bindings available
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shells
