#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "karabiner-elements"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/karabiner" "$module/config"
EOF
