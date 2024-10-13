if [ "$INSTALL" -eq 1 ]; then
    brew install --cask hammerspoon
    install-file "$XDG_CONFIG_HOME/hammerspoon" config
    defaults write org.hammerspoon.Hammerspoon MJConfigFile -string "$XDG_CONFIG_HOME/hammerspoon/init.lua" # follow XDG Base Directory, see https://github.com/Hammerspoon/hammerspoon/issues/2175
    defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool false                                # hide the Dock icon
    defaults write org.hammerspoon.Hammerspoon MJShowMenuIconKey -bool false                                # hide the menu bar icon
fi
