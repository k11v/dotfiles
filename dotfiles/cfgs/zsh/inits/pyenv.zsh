_pyenv_uninstall_lazy_init() {
    unset -f pyenv
    unset -f _pyenv
    compdef -d pyenv
}

pyenv() {
    _pyenv_uninstall_lazy_init
    eval "$(pyenv init -)"
    pyenv "$@"
}

_pyenv() {
    _pyenv_uninstall_lazy_init
    eval "$(pyenv init -)"
    _main_complete
}

compdef _pyenv pyenv
