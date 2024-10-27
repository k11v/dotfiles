#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export GOPATH="\$XDG_DATA_HOME/go"
EOF

cat << EOF >> Brewfile
brew "go"
EOF
