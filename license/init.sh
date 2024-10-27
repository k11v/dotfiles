module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
install-file "\$HOME/.local/bin/license" "$module/license"
install-file "\$XDG_CONFIG_HOME/license" "$module/config"
EOF
