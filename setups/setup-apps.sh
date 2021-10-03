#!/bin/sh

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
# Telegram
#


# Hide archived chats from all chats
defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true


#
# Cleanup
#


# Kill affected applications
for app in \
    "Transmission" \
    "Amphetamine" \
    "Rectangle" \
    "Flow" \
    "Telegram"; do
    killall "$app" &> /dev/null
done
echo "Done. Note that some of these changes require a restart to take effect."
