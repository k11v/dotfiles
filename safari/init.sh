#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
defaults write com.apple.Safari IncludeDevelopMenu -bool true # show the Develop menu in Safari
EOF
