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

# gcc. "-13"-suffixed by default. Provides `g++`, `gcc`.
g++() { /usr/local/opt/gcc/bin/g++-13 "$@" }
gcc() { /usr/local/opt/gcc/bin/gcc-13 "$@" }


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
myips() {
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

# Activate current directory's Python venv
venv() {
    local venv
    if [[ -z "$1" ]]; then
        venv="${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$(basename "$PWD")"
    elif [[ "$1" == "venv" ]]; then
        venv="$PWD/venv"
    else
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Argument 1 can only be 'venv' if provided."
        return 1
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
    elif [[ "$2" == "venv" ]]; then
        venv="$PWD/venv"
    else
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Argument 2 can only be 'venv' if provided."
        return 1
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
    if [[ -z "$1" ]]; then
        venv="${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$(basename "$PWD")"
    elif [[ "$1" == "venv" ]]; then
        venv="$PWD/venv"
    else
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Argument 1 can only be 'venv' if provided."
        return 1
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
