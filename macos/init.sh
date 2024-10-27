module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
# Apple ID

defaults write com.apple.bird optimize-storage -bool false # keep iCloud files downloaded

# Dock & Menu Bar

defaults write com.apple.dock autohide                -bool true  # automatically hide and show the Dock
defaults write com.apple.dock autohide-delay          -float 0.2  # speed up the Dock's auto-hiding
defaults write com.apple.dock autohide-time-modifier  -float 0.7  # speed up the Dock's hiding/showing animation
defaults write com.apple.dock minimize-to-application -bool true  # minimize windows into application icon in Dock
defaults write com.apple.dock persistent-apps         -array      # remove all (default) icons from Dock
defaults write com.apple.dock show-process-indicators -bool true  # show indicators for open applications in Dock
defaults write com.apple.dock show-recents            -bool false # don't show recent applications in Dock

# Mission Control

defaults write com.apple.dock mru-spaces      -bool false # don't automatically rearrange Spaces
defaults write com.apple.dock wvous-br-corner -int 1      # turn off quick note feature

# Language & Region

defaults write NSGlobalDomain AppleICUForce12HourTime -bool true                                                      # 12-hour time
defaults write NSGlobalDomain AppleICUNumberSymbols   -dict 0 -string "." 1 -string "," 10 -string "." 17 -string "," # US number separators
defaults write NSGlobalDomain AppleLanguages          -array "en-US" "ru-RU"                                          # preferred languages: English (US), Russian
defaults write NSGlobalDomain AppleLocale             -string "en_US"                                                 # region: US
defaults write NSGlobalDomain AppleMeasurementUnits   -string "Centimeters"                                           # metric measurement units
defaults write NSGlobalDomain AppleMetricUnits        -bool true                                                      # metric measurement units
defaults write NSGlobalDomain AppleTemperatureUnit    -string "Celsius"                                               # temperature: Celsius

# Keyboard

defaults write NSGlobalDomain      ApplePressAndHoldEnabled             -bool false # disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain      InitialKeyRepeat                     -int 15     # make delay until key repeat shorter
defaults write NSGlobalDomain      KeyRepeat                            -int 2      # make key repeat faster
defaults write NSGlobalDomain      NSAutomaticCapitalizationEnabled     -bool false # disable automatic capitalization
defaults write NSGlobalDomain      NSAutomaticDashSubstitutionEnabled   -bool false # disable smart dashes
defaults write NSGlobalDomain      NSAutomaticPeriodSubstitutionEnabled -bool false # disable automatic period substitution
defaults write NSGlobalDomain      NSAutomaticQuoteSubstitutionEnabled  -bool false # disable smart quotes
defaults write NSGlobalDomain      NSAutomaticSpellingCorrectionEnabled -bool false # disable auto-correct
defaults write com.apple.HIToolbox AppleDictationAutoEnable             -bool false # disable "Enable dictation" prompt when Fn key is pressed multiple times

# map "Select the previous input source" shortcut to F19 (which is managed by Karabiner)
/usr/libexec/PlistBuddy \
-c "Delete :AppleSymbolicHotKeys:60" \
-c "Add :AppleSymbolicHotKeys:60:enabled bool true" \
-c "Add :AppleSymbolicHotKeys:60:value dict" \
-c "Add :AppleSymbolicHotKeys:60:value:parameters array" \
-c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 65535" \
-c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 80" \
-c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 8388608" \
-c "Add :AppleSymbolicHotKeys:60:value:type string standard" \
"\$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

# disable "Select the next source in Input menu" shortcut
/usr/libexec/PlistBuddy \
-c "Set :AppleSymbolicHotKeys:61:enabled bool false" \
"\$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

# disable "Show Spotlight search" shortcut (in favor of Alfred)
/usr/libexec/PlistBuddy \
-c "Set :AppleSymbolicHotKeys:64:enabled bool false" \
"\$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

# disable "Show Finder search window" shortcut
/usr/libexec/PlistBuddy \
-c "Set :AppleSymbolicHotKeys:65:enabled bool false" \
"\$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

# Trackpad

defaults write NSGlobalDomain                    com.apple.trackpad.scaling -int 1 # make tracking speed faster
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength          -int 0 # enable silent clicking
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold        -int 0 # make trackpad click feel light (also set SecondClickThreshold)
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold       -int 0 # make trackpad click feel light (also set FirstClickThreshold)

# Sharing

sudo scutil --set ComputerName "Kirill's MacBook" # set computer name
sudo scutil --set LocalHostName "kirills-macbook" # set local hostname

# Other

defaults write NSGlobalDomain AppleShowAllExtensions -bool true # show all filename extensions (in open/save dialogs too)
defaults write NSGlobalDomain AppleShowAllFiles      -bool true # show hidden files (in open/save dialogs too)
EOF
