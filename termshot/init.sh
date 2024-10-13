if [ "$INSTALL" -eq 1 ]; then
    install-file "$HOME/.local/bin/termshot" termshot
    install-file "$XDG_CONFIG_HOME/termshot" config
fi
