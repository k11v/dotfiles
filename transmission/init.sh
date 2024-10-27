module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "transmission"
EOF

cat << EOF >> install.sh
defaults write org.m0k.transmission CheckRemoveDownloading   -bool true  # don't ask before removing a non-downloading transfer
defaults write org.m0k.transmission DeleteOriginalTorrent    -bool true  # trash original torrent files
defaults write org.m0k.transmission DownloadAsk              -bool false # don't ask before starting a download
defaults write org.m0k.transmission DownloadLocationConstant -bool true  # download torrents to the ~/Downloads folder
defaults write org.m0k.transmission MagnetOpenAsk            -bool false # don't ask before opening a magnet link
defaults write org.m0k.transmission RandomPort               -bool true  # randomize port on launch
defaults write org.m0k.transmission WarningDonate            -bool false # hide the donate message
defaults write org.m0k.transmission WarningLegal             -bool false # hide the legal disclaimer
EOF
