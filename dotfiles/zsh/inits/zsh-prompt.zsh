_prompt_precmd() {
    local exit_status="$?"

    local username=''
    local hostname=''
    local workdir='%B%F{cyan}%~%f%b'
    local branch=''
    local venv=''
    local symbol='%B%F{green}❯%f%b'

    # Show username and hostname when connected via SSH
    if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
        username='%B%F{yellow}%n%f%b in '
        hostname='%B%F{green}%m%f%b in '
    fi

    # Show red username for superuser
    if [[ "${EUID-}" -eq 0 ]]; then
        username='%B%F{red}%n%f%b in '
    fi

    # Show branch when in a Git repository
    local ref ref_status
    ref="$(command git symbolic-ref --quiet HEAD 2> /dev/null)"
    ref_status="$?"
    if [[ "$ref_status" -eq 128 ]]; then
        # No Git repository here
    elif [[ "$ref_status" -eq 0 ]]; then
        # Ref variable contains the current branch
        branch=" on %B%F{magenta}${ref#refs/heads/}%f%b"
    elif ref="$(command git rev-parse --short HEAD 2> /dev/null)"; then
        # HEAD is in a detached state
        branch=" on %B%F{magenta}HEAD%f%b %B%F{green}($ref)%b%f"
    fi

    # Show venv when it's activated
    if [[ -n "${VIRTUAL_ENV-}" ]]; then
        venv=" via %B%F{yellow}${VIRTUAL_ENV:t}%f%b"
    fi

    # Color symbol red if previous command failed
    if [[ "$exit_status" -ne 0 ]]; then
        symbol='%B%F{red}❯%f%b'
    fi

    PROMPT=$'\n'"$username$hostname$workdir$branch$venv"$'\n'"$symbol "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
