# Use GNU ls by default
ls() {
    /usr/local/bin/gls "$@"
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

# Get external IP
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}
