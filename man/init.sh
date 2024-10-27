module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export MANPATH="/usr/local/opt/libpq/share/man:\$MANPATH"
export MANPATH="/usr/local/opt/mysql-client/share/man:\$MANPATH"
export MANPATH="/usr/local/opt/openjdk/share/man:\$MANPATH"
EOF
