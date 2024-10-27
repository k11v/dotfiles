module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "rectangle"
EOF

cat << EOF >> install.sh
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1      # set shortcuts to Rectangle defaults
defaults write com.knollsoft.Rectangle launchOnLogin             -bool false # don't launch Rectangle on login
defaults write com.knollsoft.Rectangle hideMenubarIcon           -bool true  # hide menu bar icon
defaults write com.knollsoft.Rectangle subsequentExecutionMode   -int 2      # do nothing
defaults write com.knollsoft.Rectangle windowSnapping            -int 2      # turn off window snapping
EOF
