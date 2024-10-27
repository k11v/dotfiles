#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
brew "git"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/git" "$module/config"
EOF
