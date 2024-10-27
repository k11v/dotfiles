#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export PIP_REQUIRE_VIRTUALENV=true
EOF
