if [ "$INSTALL" -eq 1 ]; then
    install-file "$HOME/.zshenv" .zshenv
    install-file "$XDG_CONFIG_HOME/zsh" config
fi
