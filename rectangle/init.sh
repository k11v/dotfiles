module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "rectangle"
EOF

cat << EOF >> install.sh
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1
defaults write com.knollsoft.Rectangle launchOnLogin -bool false
defaults write com.knollsoft.Rectangle hideMenubarIcon -bool true
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 2
defaults write com.knollsoft.Rectangle windowSnapping -int 2
EOF
