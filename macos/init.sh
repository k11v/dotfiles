module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
defaults write com.apple.bird optimize-storage -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.2
defaults write com.apple.dock autohide-time-modifier -float 0.7
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock wvous-br-corner -int 1
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true
defaults write NSGlobalDomain AppleICUNumberSymbols -dict 0 -string "." 1 -string "," 10 -string "." 17 -string ","
defaults write NSGlobalDomain AppleLanguages -array "en-US" "ru-RU"
defaults write NSGlobalDomain AppleLocale -string "en_US"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:60" -c "Add :AppleSymbolicHotKeys:60:enabled bool true" -c "Add :AppleSymbolicHotKeys:60:value dict" -c "Add :AppleSymbolicHotKeys:60:value:parameters array" -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 65535" -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 80" -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 8388608" -c "Add :AppleSymbolicHotKeys:60:value:type string standard" "\$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
EOF
