if [ "$INSTALL" -eq 1 ]; then
    brew install --cask alacritty
    install-file "$XDG_CONFIG_HOME/alacritty" config
fi
