if [ "$INSTALL" -eq 1 ]; then
    brew install --cask font-jetbrains-mono-nerd-font
    brew install sublime-text
    install-file "$HOME/Library/Application Support/Sublime Text" config
fi
