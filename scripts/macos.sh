#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

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

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

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

###############################################################################
# Finder                                                                      #
###############################################################################

# Set home as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string 'PfHm'
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Show only external devices on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

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

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0.2

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.7

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Enable the Develop menu in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it's annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# GPGMail 2                                                                   #
###############################################################################

# Disable signing emails by default
defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

# Expand the print dialog by default
defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

###############################################################################
# SizeUp.app                                                                  #
###############################################################################

# Start SizeUp at login
defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

# Don't show the preferences window on next start
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

###############################################################################
# Sublime Text                                                                #
###############################################################################

# Install Sublime Text settings
cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

###############################################################################
# Spectacle.app                                                               #
###############################################################################

# Set up my preferred keyboard shortcuts
cp -r init/spectacle.json ~/Library/Application\ Support/Spectacle/Shortcuts.json 2> /dev/null

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use '~/Documents/Torrents' to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Use '~/Downloads' to store completed downloads
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

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true

###############################################################################
# Twitter.app                                                                 #
###############################################################################

# Disable smart quotes as it's annoying for code tweets
defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

# Show the app window when clicking the menu bar icon
defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

# Enable the hidden ‘Develop' menu
defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

# Open links in the background
defaults write com.twitter.twitter-mac openLinksInBackground -bool true

# Allow closing the ‘new tweet' window by pressing 'Esc'
defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

# Show full names rather than Twitter handles
defaults write com.twitter.twitter-mac ShowFullNames -bool true

# Hide the app in the background if it's not the front-most window
defaults write com.twitter.twitter-mac HideInBackground -bool true

###############################################################################
# Tweetbot.app                                                                #
###############################################################################

# Bypass the annoyingly slow t.co URL shortener
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Opera" \
    "Photos" \
    "Safari" \
    "SizeUp" \
    "Spectacle" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission" \
    "Tweetbot" \
    "Twitter" \
    "iCal"; do
    killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
