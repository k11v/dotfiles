#!/bin/sh

mixins="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/mixins"
source "$mixins/exit.sh"
source "$mixins/require.sh"


require_environment
require_macos
require_macos_application "Transmission"


defaults write org.m0k.transmission DownloadAsk -bool false              # Don't ask before starting a download
defaults write org.m0k.transmission MagnetOpenAsk -bool false            # Don't ask before opening a magnet link
defaults write org.m0k.transmission CheckRemoveDownloading -bool true    # Don't ask before removing a non-downloading transfer
defaults write org.m0k.transmission DownloadLocationConstant -bool true  # Download torrents to the ~/Downloads folder
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true     # Trash original torrent files
defaults write org.m0k.transmission WarningDonate -bool false            # Hide the donate message
defaults write org.m0k.transmission WarningLegal -bool false             # Hide the legal disclaimer
defaults write org.m0k.transmission RandomPort -bool true                # Randomize port on launch

killall "Transmission" &> /dev/null
exit_with_success
