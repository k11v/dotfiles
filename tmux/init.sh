module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
brew "tmux"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/tmux" "$module/config"
EOF
