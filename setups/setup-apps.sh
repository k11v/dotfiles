#!/bin/sh

#
# Transmission
#


defaults write org.m0k.transmission DownloadAsk -bool false                 # Don't ask before starting a download
defaults write org.m0k.transmission MagnetOpenAsk -bool false               # Don't ask before opening a magnet link
defaults write org.m0k.transmission CheckRemoveDownloading -bool true       # Don't ask before removing a non-downloading transfer
defaults write org.m0k.transmission DownloadLocationConstant -bool true     # Download torrents to the ~/Downloads folder
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true        # Trash original torrent files
defaults write org.m0k.transmission WarningDonate -bool false               # Hide the donate message
defaults write org.m0k.transmission WarningLegal -bool false                # Hide the legal disclaimer
defaults write org.m0k.transmission RandomPort -bool true                   # Randomize port on launch


#
# Amphetamine
#


defaults write com.if.Amphetamine "Show Welcome Window" -bool false         # Don't show welcome window
defaults write com.if.Amphetamine "Enable Session State Sound" -bool false  # Don't play sound when any session starts or ends
defaults write com.if.Amphetamine "Icon Style" -int 5                       # Set menu bar icon to a coffee cup


#
# Rectangle
#



defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1     # Set shortcuts to Rectangle defaults
defaults write com.knollsoft.Rectangle launchOnLogin -bool false            # Don't launch Rectangle on login
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1       # Move to adjacent display on repeated left or right commands
defaults write com.knollsoft.Rectangle windowSnapping -int 2                # Turn off window snapping


#
# Flow
#


defaults write design.yugen.Flow showWelcomeWindow -bool false              # Don't show welcome window


#
# Telegram
#


defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true            # Hide archived chats from All Chats

# Kill affected programs

for program in \
    "Transmission" \
    "Amphetamine" \
    "Rectangle" \
    "Flow" \
    "Telegram"; do
    killall "$program" &> /dev/null
done
