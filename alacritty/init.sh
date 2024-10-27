#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "alacritty"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/alacritty" "$module/config"
EOF
