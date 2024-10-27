module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "hammerspoon"
EOF

cat << EOF >> install.sh
install-file "\$XDG_CONFIG_HOME/hammerspoon" "$module/config"
defaults write org.hammerspoon.Hammerspoon MJConfigFile -string "\$XDG_CONFIG_HOME/hammerspoon/init.lua" # follow XDG Base Directory, see https://github.com/Hammerspoon/hammerspoon/issues/2175
defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool false                                # hide the Dock icon
defaults write org.hammerspoon.Hammerspoon MJShowMenuIconKey -bool false                                # hide the menu bar icon
EOF
