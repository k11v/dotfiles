if [ "$INSTALL" -eq 1 ]; then
    install-file "$XDG_CONFIG_HOME/readline" config
fi

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
