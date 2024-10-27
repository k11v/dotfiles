#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "font-jetbrains-mono-nerd-font"
brew "sublime-text"
EOF

cat << EOF >> install.sh
install-file "\$HOME/Library/Application Support/Sublime Text" "$module/config"
EOF
