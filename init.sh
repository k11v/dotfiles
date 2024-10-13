if [ -e "$DOTFILES_HOME" ]; then
    init_cwd="$(pwd)"

    if [ "$INSTALL" -eq 1 ]; then
        # install_file <dst> <src> installs a file at dst by symlinking a file at src.
        install-file() {
            # if file is already installed, return
            if [ -L "$dst" ] && [ "$(readlink -- "$dst")" = "$src" ]; then
                return 0
            fi
            # if file is a broken link, remove it
            if [ -L "$dst" ] && [ ! -e "$dst" ]; then
                rm -- "$dst"
            fi
            # if file still exists, return with error
            if [ -e "$dst" ]; then
                echo "error: file already exists: $dst" >&2
                return 1
            fi
            ln -s -- "$src" "$dst"
        }
    fi

    cd -- "$DOTFILES_HOME" > /dev/null
    for module in */; do
        module="${module%/}"
        CDPATH= cd -- "$module" > /dev/null
        [ "$INSTALL" -eq 1 ] && printf "%b%s%b%b%s%b\n" "\e[1;35m" "Installing" "\e[0m" "\e[1m" " $module" "\e[0m"
        source init.sh
        cd -- "$DOTFILES_HOME" > /dev/null
    done

    cd -- "$init_cwd" > /dev/null
else
    echo "error: DOTFILES_HOME doesn't exist: $DOTFILES_HOME" >&2
fi
