if [ "$INSTALL" -eq 1 ]; then
    install-file "$HOME/.local/bin/license" license
    install-file "$XDG_CONFIG_HOME/license" config
fi
