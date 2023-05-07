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
    local name="$(basename "$PWD")"

    if [[ ! -e "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' doesn't exist."
        return 1
    fi

    source "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name/bin/activate"
}

# Activate current directory's Python venv (h)ere
venvh() {
    if [[ ! -e "$PWD/venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv(h) doesn't exist."
        return 1
    fi

    source "$PWD/venv/bin/activate"
}

# Create current directory's Python venv (with optional version)
mkvenv() {
    local version="${1-$(pyenv versions --bare | grep -P '^\d+(\.\d+)*$' | tail -1)}"
    local name="$(basename "$PWD")"

    if [[ -z "$version" ]]; then
        local last_version="$(pyenv install --list | grep -E '^[[:space:]]*[[:digit:]]+(\.[[:digit:]]+)*[[:space:]]*$' | tail -1 | xargs)"
        pyenv install --skip-existing "$last_version"
        [[ "$?" -ne 0 ]] && return 1
        version="$last_version"
    fi

    if [[ -e "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' already exists."
        return 1
    fi

    if ! pyenv versions --bare | grep -P -q "^$version\$"; then
        pyenv install --skip-existing "$version"
        [[ "$?" -ne 0 ]] && return 1
    fi

    echo "Making venv '$name' with Python $version..."

    PYENV_VERSION="$version" python -m venv "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name"
    [[ "$?" -ne 0 ]] && return 1

    source "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name/bin/activate"
}

# Create current directory's Python venv (h)ere (with optional version)
mkvenvh() {
    local version="${1-$(pyenv versions --bare | grep -P '^\d+(\.\d+)*$' | tail -1)}"

    if [[ -z "$version" ]]; then
        local last_version="$(pyenv install --list | grep -E '^[[:space:]]*[[:digit:]]+(\.[[:digit:]]+)*[[:space:]]*$' | tail -1 | xargs)"
        pyenv install --skip-existing "$last_version"
        [[ "$?" -ne 0 ]] && return 1
        version="$last_version"
    fi

    if [[ -e "$PWD/venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv(h) already exists."
        return 1
    fi

    if ! pyenv versions --bare | grep -P -q "^$version\$"; then
        pyenv install --skip-existing "$version"
        [[ "$?" -ne 0 ]] && return 1
    fi

    echo "Making venv(h) with Python $version..."

    PYENV_VERSION="$version" python -m venv "$PWD/venv"
    [[ "$?" -ne 0 ]] && return 1

    source "$PWD/venv/bin/activate"
}

# Delete current directory's Python venv
rmvenv() {
    local name="$(basename "$PWD")"

    if [[ ! -e "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' doesn't exist."
        return 1
    fi

    if [[ "$VIRTUAL_ENV" -ef "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name" ]]; then
        deactivate
        [[ "$?" -ne 0 ]] && return 1
    fi

    rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/venv/venvs/$name"
}

# Delete current directory's Python venv (h)ere
rmvenvh() {
    if [[ ! -e "$PWD/venv" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv(h) doesn't exist."
        return 1
    fi

    if [[ "$VIRTUAL_ENV" -ef "$PWD/venv" ]]; then
        deactivate
        [[ "$?" -ne 0 ]] && return 1
    fi

    rm -rf "$PWD/venv"
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
