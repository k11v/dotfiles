export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if [ "$INSTALL" -eq 1 ]; then
    brew install pyenv
fi
