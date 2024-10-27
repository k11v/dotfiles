#/bin/sh

module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> Brewfile
cask "telegram"
EOF

cat << EOF >> install.sh
defaults write ru.keepcoder.Telegram kArchiveIsHidden -bool true # hide archived chats from All Chats
EOF
