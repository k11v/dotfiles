if [ "$INSTALL" -eq 1 ]; then
    mas install 937984704 # Amphetamine
    defaults write com.if.Amphetamine "Show Welcome Window" -bool false        # don't show welcome window
    defaults write com.if.Amphetamine "Enable Session State Sound" -bool false # don't play sound when any session starts or ends
    defaults write com.if.Amphetamine "Icon Style" -int 5                      # set menu bar icon to a coffee cup
fi
