if [ "$INSTALL" -eq 1 ]; then
    brew install --cask jetbrains-toolbox
    install-file "$XDG_CONFIG_HOME/ideavim" config/ideavim
fi
