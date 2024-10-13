if [ "$INSTALL" -eq 1 ]; then
    mas install 1423210932 # Flow
    defaults write design.yugen.Flow showWelcomeWindow -bool false # don't show welcome window
fi
