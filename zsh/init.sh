export FPATH="$XDG_CONFIG_HOME/zsh/completions:$FPATH"
export HISTFILE="$XDG_DATA_HOME/zsh/.zhistory"
export HISTSIZE=10000
export KEYTIMEOUT=1
export PROMPT_EOL_MARK=""
export PROMPT_STYLE="regular"                     # User-defined
export PS2="%B…%b "
export SAVEHIST=10000
export ZCOMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump" # User-defined

if [ "$INSTALL" -eq 1 ]; then
    install-file "$HOME/.zshenv" .zshenv
    install-file "$XDG_CONFIG_HOME/zsh" config
fi
