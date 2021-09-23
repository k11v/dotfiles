# Lazy init pyenv either through the command or through the completion
_pyenv_init() {
    # The second run of this function will be harmful to the environment
    unfunction _pyenv_init

    # Remove lazy functions and completers in favor of whatever the init brings
    unfunction pyenv
    unfunction _pyenv
    compdef -d pyenv

    # Initialize pyenv to get new 'pyenv' function and completions
    eval "$(pyenv init -)"
}
pyenv() {
    # Intercept pyenv call to perform initialization
    _pyenv_init

    # Perform the real pyenv call after initialization
    pyenv "$@"

}
_pyenv() {
    # Intercept pyenv completion to perform initialization
    _pyenv_init

    # Perform the real pyenv completion after initialization
    _main_complete
}
compdef _pyenv pyenv
