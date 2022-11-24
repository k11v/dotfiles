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

# Quickly jump into a repository
repo() {
    cd "$REPOSITORIES/$1"
}

# Quickly jump into a note directory
note() {
    cd "$NOTES/$1"
}

# Quickly jump into a suite directory
suite() {
    cd "$SUITES/$1"
}

# Load a .env file (formatted according to the Compose spec)
dotenv() {
    local kv
    cat "$1" | sed '/^#.*$/d' | sed '/^$/d' | sed -n '/^.*=.*$/p' | while read -r kv; do
        export "$kv"
    done
}
