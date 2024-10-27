module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
mas "Flow", id: 1423210932
EOF

cat << EOF >> install.sh
defaults write design.yugen.Flow showWelcomeWindow -bool false # don't show welcome window
EOF
