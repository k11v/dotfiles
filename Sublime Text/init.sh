if [ "$INSTALL" -eq 1 ]; then
    # brew install font-jetbrains-mono
    brew install sublime-text
    install-link "$HOME/Library/Application Support/Sublime Text" config # https://www.sublimetext.com/docs/revert.html
fi
