if [ "$INSTALL" -eq 1 ]; then
    brew install --cask karabiner-elements
    install-file "$XDG_CONFIG_HOME/karabiner" config
fi
