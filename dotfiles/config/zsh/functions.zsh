# GNU utils

# binutils. Not symlinked by default. Provides GNU `strings`, etc.
strings() { /usr/local/opt/binutils/bin/strings "$@"; }

# coreutils. G-prefixed by default. Provides GNU `cp`, `ls`, `rm`, etc.
ls() { /usr/local/opt/coreutils/libexec/gnubin/ls "$@"; }

# gnu-sed. G-prefixed by default. Provides GNU `sed`.
sed() { /usr/local/opt/gnu-sed/libexec/gnubin/sed "$@"; }

# grep. G-prefixed by default. Provides GNU `egrep`, `fgrep`, `grep`.
egrep() { /usr/local/opt/grep/libexec/gnubin/egrep "$@"; }
fgrep() { /usr/local/opt/grep/libexec/gnubin/fgrep "$@"; }
grep() { /usr/local/opt/grep/libexec/gnubin/grep "$@"; }

# gcc. "-13"-suffixed by default. Provides `g++`, `gcc`, etc.
g++() { /usr/local/opt/gcc/bin/g++-13 "$@" }
gcc() { /usr/local/opt/gcc/bin/gcc-13 "$@" }


# Competitive programming utils

gentest() {
    if [ -z "$1" ] || [ ! -e "$1" ] || [ -z "$2" ] || [ ! -e "$2" ] || [ -z "$3" ] || [ ! -e "$3" ]; then
        if [ -z "$1" ]; then
            echo "Error: Generator program not provided." >&2
        elif [ ! -e "$1" ]; then
            echo "Error: Generator program not found: $1" >&2
        fi
        if [ -z "$2" ]; then
            echo "Error: Correct program not provided." >&2
        elif [ ! -e "$2" ]; then
            echo "Error: Correct program not found: $2" >&2
        fi
        if [ -z "$3" ]; then
            echo "Error: Examined program not provided." >&2
        elif [ ! -e "$3" ]; then
            echo "Error: Examined program not found: $3" >&2
        fi
        echo "Usage: gentest <generator> <correct> <examined>" >&2
        return 1
    fi

    i=0
    while ((++i)); do
        echo "$i"
        "$1" "$i" > int
        command diff <("$2" < int) <("$3" < int) || break
    done
}

bc++11() {
    if [ -z "$1" ]; then
        echo "Error: The input file must be provided." >&2
        return 1
    fi

    if [ "$1" = "$(basename "$1" ".cpp")" ]; then
        echo "Error: The name of the input file must end with '.cpp'." >&2
        return 1
    fi

    g++ -std=c++11 -Og -Wall -Wextra -o "$(basename "$1" ".cpp")" "$1"
}

bc++11-prod() {
    if [ -z "$1" ]; then
        echo "Error: The input file must be provided." >&2
        return 1
    fi

    if [ "$1" = "$(basename "$1" ".cpp")" ]; then
        echo "Error: The name of the input file must end with '.cpp'." >&2
        return 1
    fi

    g++ -std=c++11 -O2 -Wall -Wextra -o "$(basename "$1" ".cpp")" "$1"
}

rpython3.5() {
    if [ -z "$1" ]; then
        echo "Error: The input file must be provided." >&2
        return 1
    fi

    PYENV_VERSION="3.5" pyenv exec python3.5 "$1"
}


# My utils

# Change working directory to the top-most Finder window location
cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Compare files using Git's colored diff
diff() {
    git diff --no-index "$@"
}

# Get local IPs
myip() {
    ifconfig | grep inet | grep -v inet6 | cut -d " " -f 2
}

# Get external IP
myexternalip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Load a .env file (formatted according to the Compose spec)
dotenv() {
    local kv
    cat "${1-.env}" | sed '/^#.*$/d' | sed '/^$/d' | sed -n '/^.*=.*$/p' | while read -r kv; do
        export "$kv"
    done
}

# Generate a v4 UUID
uuid4() {
    python3 -c "import uuid; print(uuid.uuid4())"
}

# Activate current directory's Python venv
venv() {
    local venv
    if [[ -e "$PWD/venv" ]]; then
        venv="$PWD/venv"
    elif [[ -e "$PWD/.venv" ]]; then
        venv="$PWD/.venv"
    else
        venv="${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$(basename "$PWD")"
    fi

    if [[ ! -e "$venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv doesn't exist: $venv"
        return 1
    fi

    source "$venv/bin/activate"
}

# Create current directory's Python venv (with optional version)
mkvenv() {
    local version="${1-$(pyenv versions --bare | grep -P '^\d+(\.\d+)*$' | tail -1)}"
    local venv
    if [[ -z "$2" ]]; then
        venv="${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$(basename "$PWD")"
    else
        venv="$PWD/$2"
    fi

    if [[ -z "$version" ]]; then
        local last_version="$(pyenv install --list | grep -E '^[[:space:]]*[[:digit:]]+(\.[[:digit:]]+)*[[:space:]]*$' | tail -1 | xargs)"
        pyenv install --skip-existing "$last_version"
        [[ "$?" -ne 0 ]] && return 1
        version="$last_version"
    fi

    if [[ -e "$venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv already exists: $venv"
        return 1
    fi

    if ! pyenv versions --bare | grep -P -q "^$version\$"; then
        pyenv install --skip-existing "$version"
        [[ "$?" -ne 0 ]] && return 1
    fi

    echo "Making venv '$venv' with Python $version..."

    PYENV_VERSION="$version" python -m venv "$venv"
    [[ "$?" -ne 0 ]] && return 1

    source "$venv/bin/activate"
}

# Delete current directory's Python venv
rmvenv() {
    local venv
    if [[ -e "$PWD/venv" ]]; then
        venv="$PWD/venv"
    elif [[ -e "$PWD/.venv" ]]; then
        venv="$PWD/.venv"
    else
        venv="${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$(basename "$PWD")"
    fi

    if [[ ! -e "$venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv doesn't exist: $venv"
        return 1
    fi

    if [[ "$VIRTUAL_ENV" -ef "$venv" ]]; then
        deactivate
        [[ "$?" -ne 0 ]] && return 1
    fi

    rm -rf "$venv"
}

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}

# Quickly jump into a workspace
space() {
    cd "$WORKSPACES/$1"
}

# Quickly jump into a note
note() {
    cd "$NOTES/$1"
}

git-log-with-dates() {
    # See:
    # - https://devhints.io/git-log-format
    # - https://www.git-scm.com/docs/git-config#Documentation/git-config.txt-color
    # - https://www.git-scm.com/docs/git-log#_pretty_formats
    git log --pretty='format:%aD %C(bold)%C(yellow)%h%Creset %s'
}

# NOTE: This function creates dangling commits.
git-branch-squash-merged() {
    local branches="$(git branch --format="%(refname:short)")"
    local current_branch="$(git branch --show-current --format="%(refname:short)")"
    local default_branch="main"

    if [[ "$current_branch" != "$default_branch" ]]; then
        echo 1>&2 "Error: You must be on the default branch ('$default_branch') to run this command."
        return 1
    fi

    echo "$branches" | while read -r branch; do
        if [[ "$branch" == "$default_branch" ]]; then
            continue
        fi

        local ancestor_commit="$(git merge-base "$branch" "$default_branch")"
        local branch_tree="$(git rev-parse "$branch^{tree}")"
        local recreated_squash_commit="$(git commit-tree "$branch_tree" -p "$ancestor_commit" -m "Recreated squash commit for '$branch'")"

        if [[ -z "$recreated_squash_commit" ]]; then
            echo >&2 "Error: Failed to recreate squash commit for '$branch'. Skipping."
            continue
        fi

        if [[ $(git cherry "$default_branch" "$recreated_squash_commit") != "-"* ]]; then
            continue
        fi

        echo "$branch"
    done
}

# Compile completion cache from scratch
recompinit() {
    rm "$ZCOMPDUMP"
    compinit -d "$ZCOMPDUMP"
}

# Pipe to browser
bcat() {
    local tempdir="$(mktemp -d)"
    cat > "$tempdir/document.html"
    open "$tempdir/document.html"
    sleep 0.2
    rm -rf -- "$tempdir"
}

# Display the current date in UTC and ISO 8601 format
now() {
    date -u "+%Y-%m-%dT%H:%M:%SZ"
}

# Get website's title
titleof() {
    curl -sSL -o - -- "$1" | perl -l -0777 -n -e 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si'
}

# Activate shared Python venv
shvenv() {
    source "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/shared/bin/activate"
}

# https://stackoverflow.com/questions/4438306/how-to-remove-trailing-whitespaces-with-sed
anyfmt() {
    /usr/local/opt/gnu-sed/libexec/gnubin/sed -i 's/[ \t]*$//' "$1"
}

printcolors() {
    printf "%s %s%s%s %s%s%s %s%s%s\n" \
        " " ""                "NORMAL " ""             "$(tput bold)"                "BOLD NORMAL " "$(tput sgr0)" ""                "BACKGROUND NORMAL " ""             \
        "0" "$(tput setaf 0)" "BLACK  " "$(tput sgr0)" "$(tput bold)$(tput setaf 0)" "BOLD BLACK  " "$(tput sgr0)" "$(tput setab 0)" "BACKGROUND BLACK  " "$(tput sgr0)" \
        "1" "$(tput setaf 1)" "RED    " "$(tput sgr0)" "$(tput bold)$(tput setaf 1)" "BOLD RED    " "$(tput sgr0)" "$(tput setab 1)" "BACKGROUND RED    " "$(tput sgr0)" \
        "2" "$(tput setaf 2)" "GREEN  " "$(tput sgr0)" "$(tput bold)$(tput setaf 2)" "BOLD GREEN  " "$(tput sgr0)" "$(tput setab 2)" "BACKGROUND GREEN  " "$(tput sgr0)" \
        "3" "$(tput setaf 3)" "YELLOW " "$(tput sgr0)" "$(tput bold)$(tput setaf 3)" "BOLD YELLOW " "$(tput sgr0)" "$(tput setab 3)" "BACKGROUND YELLOW " "$(tput sgr0)" \
        "4" "$(tput setaf 4)" "BLUE   " "$(tput sgr0)" "$(tput bold)$(tput setaf 4)" "BOLD BLUE   " "$(tput sgr0)" "$(tput setab 4)" "BACKGROUND BLUE   " "$(tput sgr0)" \
        "5" "$(tput setaf 5)" "MAGENTA" "$(tput sgr0)" "$(tput bold)$(tput setaf 5)" "BOLD MAGENTA" "$(tput sgr0)" "$(tput setab 5)" "BACKGROUND MAGENTA" "$(tput sgr0)" \
        "6" "$(tput setaf 6)" "CYAN   " "$(tput sgr0)" "$(tput bold)$(tput setaf 6)" "BOLD CYAN   " "$(tput sgr0)" "$(tput setab 6)" "BACKGROUND CYAN   " "$(tput sgr0)" \
        "7" "$(tput setaf 7)" "WHITE  " "$(tput sgr0)" "$(tput bold)$(tput setaf 7)" "BOLD WHITE  " "$(tput sgr0)" "$(tput setab 7)" "BACKGROUND WHITE  " "$(tput sgr0)"
}

lspypi() {
    curl -fsSL -H "Accept: application/vnd.pypi.simple.v1+json" "https://pypi.org/simple/$1/" | jq --raw-output ".versions[]" | sort --version-sort
}
