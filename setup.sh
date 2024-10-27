#/bin/sh

set -e

# Generate

repo_home="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
data_home="$HOME/.local/share/dotfiles"
mkdir -p -- "$data_home"

cur="$data_home/current"
new="$data_home/$(date -u "+%Y%m%d%H%M%S")"
mkdir -p -- "$new"
CDPATH= cd -- "$new"

touch install.sh
chmod +x install.sh
cat << 'EOF' >> install.sh
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
EOF

for module in "$repo_home"/*/; do
    cat << EOF >> install.sh
echo 'Installing $(basename -- "$module")'
EOF
    if [ -e "$module/init.sh" ]; then
        "$module/init.sh"
    fi
done

rm -f -- "$cur"
ln -s -- "$new" "$cur"

# Install

brew bundle --file "$cur/Brewfile"
brew bundle --file "$cur/Brewfile cleanup --force"
"$cur/install.sh"
