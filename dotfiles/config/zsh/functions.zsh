# Use GNU ls by default
ls() {
    /usr/local/bin/gls "$@"
}

# Use GNU sed by default
sed() {
    /usr/local/bin/gsed "$@"
}

# Use newer git by default
git() {
    /usr/local/bin/git "$@"
}

# Use GNU strings by default
strings() {
    /usr/local/opt/binutils/bin/strings "$@"
}

# Change working directory to the top-most Finder window location
cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Compile completion cache from scratch
recompinit() {
    rm "$ZCOMPDUMP"
    compinit -d "$ZCOMPDUMP"
}

# Compare files using Git's colored diff
diff() {
    git diff --no-index "$@"
}

# Get local IP
myip() {
    ipconfig getifaddr en0
}

# Get external IP
myexternalip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}

# Quickly jump into a space
space() {
    cd "$SPACES/$1"
}

# Load a .env file (formatted according to the Compose spec)
dotenv() {
    local kv
    cat "$1" | sed '/^#.*$/d' | sed '/^$/d' | sed -n '/^.*=.*$/p' | while read -r kv; do
        export "$kv"
    done
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
