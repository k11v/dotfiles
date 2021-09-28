#!/bin/sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &


#
# General
#


# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set language and region settings
defaults write NSGlobalDomain AppleLocale -string 'en_RU'
defaults write NSGlobalDomain AppleLanguages -array 'en-US' 'ru-RU'
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true
defaults write NSGlobalDomain AppleICUNumberSymbols -dict \
    0 -string '.' \
    1 -string ',' \
    10 -string '.' \
    17 -string ','
defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string 'Celsius'

# Use a 12-hour clock in menu bar
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  h:mm a'


#
# Finder
#


# Set home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string 'PfHm'
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Show only external devices on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Show hidden files by default (in open/save dialogs as well)
defaults write NSGlobalDomain AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:arrangeBy grid' "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c 'Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid' "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:arrangeBy grid' "$HOME/Library/Preferences/com.apple.finder.plist"

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'

# Show the ~/Library folder
chflags nohidden "$HOME/Library" && xattr -d com.apple.FinderInfo "$HOME/Library"

# Show the /Volumes folder
sudo chflags nohidden '/Volumes'


#
# Mission Control
#


# Minimize windows into their application's icon in the Dock
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0.2

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.7

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Don't automatically rearrange Spaces
defaults write com.apple.dock mru-spaces -bool false


#
# Safari
#


# Enable the Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true


#
# Time Machine
#


# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


#
# App Store
#


# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true


#
# Photos
#


# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


#
# Transmission
#


# Use the downloads folder to store downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Don't prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don't prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false

# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true


#
# Amphetamine
#


# Do not show welcome window
defaults write com.if.Amphetamine "Show Welcome Window" -bool false

# Do not play sound when any session starts or ends
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false

# Set menu bar icon to a coffee cup
defaults write com.if.Amphetamine "Icon Style" -int 5



#
# Rectangle
#


# Set shortcuts to Rectangle defaults
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1

# Do not launch Rectangle on login
defaults write com.knollsoft.Rectangle launchOnLogin -bool false

# Move to adjacent display on repeated left or right commands
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1

# Turn off window snapping
defaults write com.knollsoft.Rectangle windowSnapping -int 2


#
# Flow
#


# Do not show welcome window
defaults write design.yugen.Flow showWelcomeWindow -bool false


#
# Cleanup
#


# Kill affected applications
for app in \
    'Activity Monitor' \
    'Address Book' \
    'Calendar' \
    'cfprefsd' \
    'Contacts' \
    'Dock' \
    'Finder' \
    'Mail' \
    'Messages' \
    'Photos' \
    'Safari' \
    'SystemUIServer' \
    'Terminal' \
    'Transmission' \
    'Amphetamine' \
    'Rectangle' \
    'Flow' \
    'iCal'; do
    killall "$app" &> /dev/null
done
echo "Done. Note that some of these changes require a restart to take effect."
