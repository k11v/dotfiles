module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
install-file "\$HOME/.local/bin/autotermshot" "$module/autotermshot"
EOF
