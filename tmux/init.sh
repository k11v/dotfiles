if [ "$INSTALL" -eq 1 ]; then
    brew install tmux
    install-file "$XDG_CONFIG_HOME/tmux" config
fi
