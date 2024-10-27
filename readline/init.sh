module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export INPUTRC="\$XDG_CONFIG_HOME/readline/inputrc"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/readline" "$module/config"
EOF
