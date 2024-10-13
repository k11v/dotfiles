if [ "$INSTALL" -eq 1 ]; then
    brew install git
    install-file "$XDG_CONFIG_HOME/git" config
fi
