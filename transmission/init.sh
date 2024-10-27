module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "transmission"
EOF

cat << EOF >> install.sh
defaults write org.m0k.transmission CheckRemoveDownloading -bool true
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission RandomPort -bool true
defaults write org.m0k.transmission WarningDonate -bool false
defaults write org.m0k.transmission WarningLegal -bool false
EOF
