module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export PYENV_ROOT="\$XDG_DATA_HOME/pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
EOF

cat << EOF >> Brewfile
brew "pyenv"
EOF
