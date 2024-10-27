module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export WORKSPACES="\$HOME/Workspaces"
EOF
