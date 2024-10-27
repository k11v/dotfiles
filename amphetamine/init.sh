module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
mas "Amphetamine", id: 937984704
EOF

cat << EOF >> install.sh
defaults write com.if.Amphetamine "Show Welcome Window" -bool false
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false
defaults write com.if.Amphetamine "Icon Style" -int 5
EOF
