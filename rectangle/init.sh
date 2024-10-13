if [ "$INSTALL" -eq 1 ]; then
    brew install --cask rectangle
    defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1      # set shortcuts to Rectangle defaults
    defaults write com.knollsoft.Rectangle launchOnLogin             -bool false # don't launch Rectangle on login
    defaults write com.knollsoft.Rectangle hideMenubarIcon           -bool true  # hide menu bar icon
    defaults write com.knollsoft.Rectangle subsequentExecutionMode   -int 2      # do nothing
    defaults write com.knollsoft.Rectangle windowSnapping            -int 2      # turn off window snapping
fi
