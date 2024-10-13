if [ "$INSTALL" -eq 1 ]; then
    brew install --cask telegram
    defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true # hide archived chats from All Chats
fi
