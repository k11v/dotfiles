module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
mas "Amphetamine", id: 937984704
EOF

cat << EOF >> install.sh
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false # don't play sound when any session starts or ends
defaults write com.if.Amphetamine "Icon Style" -int 5                      # set menu bar icon to a coffee cup
defaults write com.if.Amphetamine "Show Welcome Window" -bool false        # don't show welcome window
EOF
