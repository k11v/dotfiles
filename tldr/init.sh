export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"

if [ "$INSTALL" -eq 1 ]; then
    install-file "$XDG_CONFIG_HOME/tealdeer" config
    tldr --update # implementation specific, works for tealdeer
fi
