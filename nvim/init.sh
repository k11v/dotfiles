module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "neovim"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/nvim" "$module/config"
EOF
