#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export TEALDEER_CONFIG_DIR="\$XDG_CONFIG_HOME/tealdeer"
EOF

cat << EOF >> Brewfile
brew "tealdeer"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/tealdeer" "$module/config"
tldr --update # implementation specific, works for tealdeer
EOF
