if [ "$INSTALL" -eq 1 ]; then
    brew install --cask neovim
    install-file "$XDG_CONFIG_HOME/nvim" config
fi
