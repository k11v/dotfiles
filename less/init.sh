#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export LESS_TERMCAP_mb=\$'\e[1;31m'
export LESS_TERMCAP_md=\$'\e[1;36m'
export LESS_TERMCAP_me=\$'\e[0m'
export LESS_TERMCAP_so=\$'\e[01;44;33m'
export LESS_TERMCAP_se=\$'\e[0m'
export LESS_TERMCAP_us=\$'\e[1;32m'
export LESS_TERMCAP_ue=\$'\e[0m'
export LESS="-g -i -M -R -S -x4 --mouse --wheel-lines=5"
EOF

cat << EOF >> Brewfile
brew "less"
EOF
