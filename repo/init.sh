module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export REPOSITORIES="\$HOME/Repositories"
EOF
