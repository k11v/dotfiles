#! /bin/zsh

killall iTerm2


cur_dir="$0:A:h"

settings_filename="com.googlecode.iterm2.plist"
settings_file="$HOME/Library/Preferences/$settings_filename"


if [[ -f "$settings_file" ]]; then
    echo "File $settings_file exists. Backing up..."
    cp "$settings_file" "$cur_dir/$settings_filename.bak"
fi

cp "$cur_dir/$filename" "$HOME/Library/Preferences/$filename"


unset cur_dir
unset settings_filename
unset settings_file
