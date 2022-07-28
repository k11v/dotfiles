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

# Quickly jump into a local files directory
local() {
    cd "$LOCAL_FILES/$1"
}

# Quickly jump into a remote files directory
remote() {
    cd "$REMOTE_FILES/$1"
}

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}

# Quickly jump into a suite directory
suite() {
    cd "$SUITES/$1"
}
