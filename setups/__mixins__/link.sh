link() {
    src="$1"
    dst="$2"

    filename="$(basename "$src")"

    if [ "$(readlink "$dst")" = "$src" ]; then
        echo "Using $filename"
        return 0
    fi

    if [ -L "$dst" ] && [ ! -e "$dst" ]; then
        is_broken_link_at_destination=1
        activity="Relinking $filename"
    else
        is_broken_link_at_destination=0
        activity="Linking $filename"
    fi

    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    reset="$(tput sgr0)"

    printf "%s%s%s\n" "$green" "$activity" "$reset"

    if [ "$is_broken_link_at_destination" -eq 1 ]; then
        rm "$dst"
    fi

    # WTF: 'ln -s' on itself will allow
    # existing directories at destination
    if [ -e "$dst" ]; then
        has_activity_failed=1
        echo >&2 "link: $dst: File exists"
    else
        ln -s "$src" "$dst"

        if [ "$?" -ne 0 ]; then
            has_activity_failed=1
        else
            has_activity_failed=0
        fi
    fi

    if [ "$has_activity_failed" -eq 1 ]; then
        printf "%s%s%s\n" "$red" "$activity has failed" "$reset"
        return 1
    fi
}
