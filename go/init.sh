if [ "$INSTALL" -eq 1 ]; then
    brew install go
fi

export GOPATH="$XDG_DATA_HOME/go"
