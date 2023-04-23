function poetry(){
    if [[ -z "$VIRTUAL_ENV" ]]; then
        echo 2>&1 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Virtual environment is not activated."
        return 1
    fi

    command poetry "$@"
}
