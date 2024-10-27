#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
install-file "\$HOME/.local/bin/termshot" "$module/termshot"
install-file "\$XDG_CONFIG_HOME/termshot" "$module/config"
EOF
