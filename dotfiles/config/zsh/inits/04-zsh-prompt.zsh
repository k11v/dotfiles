# Prompt styles

typeset -A _prompt_builders  # Declare an associative array
_prompt_builders=()

_prompt_builders["regular"]="_make_regular_prompt"
_make_regular_prompt() {
    local exit_status="$1" git_ref git_commit git_tag
    local username hostname branch venv workdir symbol
    
    workdir="%B%F{cyan}%~%f%b"
    symbol="%B%F{green}❯%f%b"

    git_ref="$(git symbolic-ref --quiet HEAD 2> /dev/null)"
    [[ "$?" -eq 1 ]] && git_commit="$(git rev-parse --short HEAD 2> /dev/null)"
    [[ -n "$git_commit" ]] && git_tag="$(git describe --exact-match --tags "$git_commit" 2> /dev/null)"

    if [[ -d ".git" ]]; then
        workdir="%B%F{cyan}${PWD:t}%f%b"
    fi

    if [[ -n "$git_ref" ]]; then
        branch=" on %B%F{magenta}${git_ref#refs/heads/}%f%b"
    elif [[ -n "$git_tag" ]]; then
        branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($git_tag)%b%f"
    elif [[ -n "$git_commit" ]]; then
        branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($git_commit)%b%f"
    fi

    if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
        username="%B%F{yellow}%n%f%b in "
        hostname="%B%F{green}%m%f%b in "
    fi

    if [[ "${EUID-}" -eq 0 ]]; then
        username="%B%F{red}%n%f%b in "
    fi

    if [[ -n "${VIRTUAL_ENV-}" ]]; then
        venv=" via %B%F{yellow}${VIRTUAL_ENV:t}%f%b"
    elif [[ -n "${PYENV_VERSION-}" ]]; then
        venv=" via %B%F{yellow}${PYENV_VERSION}%f%b"
    fi

    if [[ "$exit_status" -ne 0 ]]; then
        symbol="%B%F{red}❯%f%b"
    fi

    printf "%s" "$username$hostname$workdir$branch$venv $symbol "
}

_prompt_builders["simple"]="_make_simple_prompt"
_make_simple_prompt() {
    local exit_status="$1"
    local symbol

    if [[ "$exit_status" -eq 0 ]]; then
        symbol="%B%F{green}❯%f%b"
    else
        symbol="%B%F{red}❯%f%b"
    fi

    printf "%s" "$symbol "
}

# Prompt precmd

_prompt_precmd() {
    local exit_status="$?"
    
    PROMPT="$("${_prompt_builders["$PROMPT_STYLE"]-_make_default_prompt}" "$exit_status")"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
