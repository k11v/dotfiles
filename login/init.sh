module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
install-file "\$HOME/.hush_login" "$module/.hush_login"
EOF
