#!/bin/sh

if [ "$DOTFILES_ENVIRONMENT_LOADED" -ne 1 ]; then
    echo >&2 "$(basename "$0"): Environment doesn't seem to be loaded"
    exit 1
fi
if [ -z "$DOTFILES_SETUP_MIXINS" ]; then
    echo >&2 "$(basename "$0"): DOTFILES_SETUP_MIXINS wasn't passed to the setup"
    exit 1
fi
source "$DOTFILES_SETUP_MIXINS/require.sh"
source "$DOTFILES_SETUP_MIXINS/exit.sh"


require_macos


# Give password to sudo upfront and prevent sudo session timeout

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &

# Prevent preferences below from being overridden by System Preferences

osascript -e 'tell application "System Preferences" to quit'

# Set Mission Control preferences

defaults write com.apple.dock mru-spaces -bool false                               # Don't automatically rearrange Spaces
defaults write com.apple.dock minimize-to-application -bool true                   # Minimize windows into application icon in Dock
defaults write com.apple.dock autohide -bool true                                  # Automatically hide and show the Dock
defaults write com.apple.dock show-process-indicators -bool true                   # Show indicators for open applications in Dock
defaults write com.apple.dock show-recents -bool false                             # Don't show recent applications in Dock
defaults write com.apple.dock persistent-apps -array                               # Remove all (default) icons from Dock
defaults write com.apple.dock autohide-delay -float 0.2                            # Speed up the Dock's auto-hiding
defaults write com.apple.dock autohide-time-modifier -float 0.7                    # Speed up the Dock's hiding/showing animation
defaults write com.apple.dock wvous-br-corner -int 1                               # Turn off quick note feature

# Set language and region preferences

defaults write NSGlobalDomain AppleLocale -string "en_US"                          # Region: US
defaults write NSGlobalDomain AppleLanguages -array "en-US" "ru-RU"                # Preferred languages: English (US), Russian
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true                   # 12-hour time
defaults write NSGlobalDomain AppleICUNumberSymbols -dict \
    0 -string "." \
    1 -string "," \
    10 -string "." \
    17 -string ","                                                                 # US number separators
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"          # Metric measurement units
defaults write NSGlobalDomain AppleMetricUnits -bool true                          # Metric measurement units
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"               # Temperature: Celsius

# Set keyboard preferences

defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                 # Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain KeyRepeat -int 2                                     # Make key repeat faster
defaults write NSGlobalDomain InitialKeyRepeat -int 15                             # Make delay until key repeat shorter

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false     # Disable auto-correct
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false         # Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false     # Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false      # Disable smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false       # Disable smart dashes

defaults write com.apple.HIToolbox AppleDictationAutoEnable -bool false            # Disable "Enable dictation" prompt when Fn key is pressed multiple times

# Set keyboard shortcuts

/usr/libexec/PlistBuddy \
    -c "Delete :AppleSymbolicHotKeys:60" \
    -c "Add :AppleSymbolicHotKeys:60:enabled bool true" \
    -c "Add :AppleSymbolicHotKeys:60:value dict" \
    -c "Add :AppleSymbolicHotKeys:60:value:parameters array" \
    -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 65535" \
    -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 80" \
    -c "Add :AppleSymbolicHotKeys:60:value:parameters: integer 8388608" \
    -c "Add :AppleSymbolicHotKeys:60:value:type string standard" \
    "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"                    # Map "Select the previous input source" shortcut to F19 (which is managed by Karabiner)

/usr/libexec/PlistBuddy \
    -c "Set :AppleSymbolicHotKeys:61:enabled bool false" \
    "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"                    # Disable "Select the next source in Input menu" shortcut

/usr/libexec/PlistBuddy \
    -c "Set :AppleSymbolicHotKeys:64:enabled bool false" \
    "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"                    # Disable "Show Spotlight search" shortcut (in favor of Alfred)

/usr/libexec/PlistBuddy \
    -c "Set :AppleSymbolicHotKeys:65:enabled bool false" \
    "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"                    # Disable "Show Finder search window" shortcut

# Set trackpad preferences

defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0        # Make trackpad click feel light (also set SecondClickThreshold)
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0       # Make trackpad click feel light (also set FirstClickThreshold)

defaults write NSGlobalDomain com.apple.trackpad.scaling -int 1                    # Make tracking speed faster

defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0          # Enable silent clicking

# Set software update preferences

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true           # Automatically check for updates
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true               # Automatically download new updates
defaults write com.apple.commerce AutoUpdate -bool true                            # Automatically install app updates

# Set iCloud preferences

defaults write com.apple.bird optimize-storage -bool false                         # Keep iCloud files downloaded

# Set Time Machine preferences

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true        # Don't prompt to use new external disks for backups

# Set Finder preferences

sudo chflags nohidden "/Volumes"                                                                # Show the /Volumes folder
chflags nohidden "$HOME/Library" && xattr -d com.apple.FinderInfo "$HOME/Library" 2> /dev/null  # Show the ~/Library folder

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"   # Snap-to-grid for icons on the desktop
/usr/libexec/PlistBuddy -c "Set :ICloudViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"    # Snap-to-grid for icons in iCloud Drive
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"  # Snap-to-grid for icons in other icon views

defaults write NSGlobalDomain AppleShowAllFiles -bool true                         # Show hidden files (in open/save dialogs too)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true                    # Show all filename extensions (in open/save dialogs too)
defaults write com.apple.finder NewWindowTarget -string "PfHm"                     # Show home for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"        # Show home for new Finder windows
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true         # Show external disks on the desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true             # Show removable media on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false                # Don't show hard drives on the desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false            # Don't show connected servers on the desktop
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false         # Don't show warning before changing an extension
defaults write com.apple.finder _FXSortFoldersFirst -bool true                     # Keep folders on top when sorting by name
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"                # Search the current folder when performing a search
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"                # Use list view in all Finder windows
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true       # Don't create .DS_Store files on network stores
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true           # Don't create .DS_Store files on USB stores

# Set Safari preferences

defaults write com.apple.Safari IncludeDevelopMenu -bool true                      # Show the Develop menu in Safari

# Set Photos preferences

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true       # Don't automatically open Photos when devices are plugged in

# Make Sublime Text 4 the default app for code files

echo "$(tput bold)Making Sublime Text 4 the default app for code files$(tput sgr0)"
for domain in com.apple.applescript.script com.apple.applescript.text com.apple.property-list com.microsoft.word.wordml com.netscape.javascript-source com.sun.java-source .md public.ada-source public.assembly-source public.bash-script public.c-header public.c-plus-plus-header public.c-plus-plus-inline-header public.c-plus-plus-source public.c-plus-plus-source.preprocessed public.c-source public.c-source.preprocessed public.comma-separated-values-text public.csh-script public.css public.data public.dylan-source public.fortran-77-source public.fortran-90-source public.fortran-95-source public.fortran-source public.html public.json public.ksh-script public.lex-source public.make-source public.mig-source public.module-map public.nasm-assembly-source public.objective-c-plus-plus-source public.objective-c-plus-plus-source.preprocessed public.objective-c-source public.objective-c-source.preprocessed public.opencl-source public.pascal-source public.perl-script public.php-script public.plain-text public.precompiled-c-header public.precompiled-c-plus-plus-header public.protobuf-source public.python-script public.ruby-script public.script public.shell-script public.source-code public.source-code.preprocessed public.swift-source public.tab-separated-values-text public.tcsh-script public.unix-executable public.xhtml public.xml public.yacc-source public.yaml public.zsh-script; do
    duti -s com.sublimetext.4 "$domain" all
done

# Kill affected programs

for program in \
    "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "iCal"; do
    killall "$program" &> /dev/null
done


exit_with_success
