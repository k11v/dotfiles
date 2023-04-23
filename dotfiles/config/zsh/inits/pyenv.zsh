_init_pyenv_once() {
    unset -f _init_pyenv_once
    unset -f pyenv
    unset -f _pyenv
    compdef -d pyenv

    eval "$(pyenv init -)"
}

pyenv() {
    _init_pyenv_once
    pyenv "$@"
}

_pyenv() {
    _init_pyenv_once
    _main_complete
}

compdef _pyenv pyenv
