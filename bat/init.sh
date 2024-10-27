#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export BAT_PAGER=""
export BAT_THEME="TwoDark"
EOF

cat << EOF >> Brewfile
brew "bat"
EOF
