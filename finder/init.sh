module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> install.sh
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"          # search the current folder when performing a search
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # don't show warning before changing an extension
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"          # use list view in all Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfHm"               # show home for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file://\$HOME/" # show home for new Finder windows
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true   # show external disks on the desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false          # don't show hard drives on the desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false      # don't show connected servers on the desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true       # show removable media on the desktop
defaults write com.apple.finder _FXSortFoldersFirst -bool true               # keep folders on top when sorting by name

/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "\$HOME/Library/Preferences/com.apple.finder.plist"  # snap-to-grid for icons on the desktop
/usr/libexec/PlistBuddy -c "Set :ICloudViewSettings:IconViewSettings:arrangeBy grid" "\$HOME/Library/Preferences/com.apple.finder.plist"   # snap-to-grid for icons in iCloud Drive
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "\$HOME/Library/Preferences/com.apple.finder.plist" # snap-to-grid for icons in other icon views
EOF
