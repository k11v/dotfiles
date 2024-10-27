#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "jetbrains-toolbox"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/ideavim" "$module/config/ideavim"
EOF
