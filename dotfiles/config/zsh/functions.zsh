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

    if [[ ! -e "$VENVS/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' doesn't exist."
        return 1
    fi

    source "$VENVS/$name/bin/activate"
}

# Create current directory's Python venv (with optional version)
mkvenv() {
    local version="${1-$(pyenv versions --bare | grep -E "^\d+(\.\d+)*$" | tail -1)}"
    local name="$(basename "$PWD")"

    if [[ -e "$VENVS/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' already exists."
        return 1
    fi

    if ! pyenv versions --bare | grep -E -q "^$version$"; then
        pyenv install --skip-existing "$version"
        [[ "$?" -ne 0 ]] && return 1
    fi

    echo "Making venv '$name' with Python $version..."

    PYENV_VERSION="$version" python -m venv "$VENVS/$name"
    [[ "$?" -ne 0 ]] && return 1

    source "$VENVS/$name/bin/activate"
}

# Delete current directory's Python venv
rmvenv() {
    local name="$(basename "$PWD")"

    if [[ ! -e "$VENVS/$name" ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Venv '$name' doesn't exist."
        return 1
    fi

    if [[ "$VIRTUAL_ENV" -ef "$VENVS/$name" ]]; then
        deactivate
        [[ "$?" -ne 0 ]] && return 1
    fi

    rm -rf "$VENVS/$name"
}

termshot() (
    local output_file="$1"

    local terminal_content_file="$(mktemp -t termshot)"
    cat > "$terminal_content_file"
    trap 'rm -f -- "$terminal_content_file"' EXIT

    alacritty \
        --config-file "$XDG_CONFIG_HOME/termshot/alacritty.yml" \
        --option window.dimensions.columns=80 \
        --option window.dimensions.lines=33 \
        --hold \
        --command "$(command -v tmux)" -f "$XDG_CONFIG_HOME/termshot/tmux.conf" -L termshot new-session cat "$terminal_content_file" &
    local terminal_pid="$!"
    trap 'rm -f -- "$terminal_content_file"; kill -- "$terminal_pid"' EXIT

    terminal_window_id="$(hs -A -q -t 10 <<EOF
local waitDuration = 5000000 -- 5 seconds
local waitInterval = 100000 -- 0.1 seconds
local app
local window

repeat
    app = app or hs.application.applicationForPID($terminal_pid)

    if app then
        window = app:mainWindow()

        if window then
            break
        end
    end

    hs.timer.usleep(hs.math.min(waitDuration, waitInterval))
    waitDuration = waitDuration - waitInterval
until waitDuration <= 0

if not app then
    error("Couldn't find application for PID '$terminal_pid'.")
end

if not window then
    error("Couldn't find window for PID '$terminal_pid'.")
end

return window:id()
EOF
    )"

    if [[ "$?" -ne 0 ]]; then
        echo >&2 "$(tput bold)$(tput setaf 1)Error:$(tput sgr0) Failed to find terminal window."
        exit 1
    fi

    screencapture -x -o -l "$terminal_window_id" "$output_file"
)

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}

# Quickly jump into a space
space() {
    cd "$SPACES/$1"
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

# Use GNU ls by default
ls() {
    /usr/local/bin/gls "$@"
}

# Use GNU sed by default
sed() {
    /usr/local/bin/gsed "$@"
}

# Use GNU strings by default
strings() {
    /usr/local/opt/binutils/bin/strings "$@"
}

# Use newer git by default
git() {
    /usr/local/bin/git "$@"
}
