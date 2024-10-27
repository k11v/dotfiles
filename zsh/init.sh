module="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat << EOF >> env.sh
export FPATH="\$XDG_CONFIG_HOME/zsh/completions:\$FPATH"
export HISTFILE="\$XDG_DATA_HOME/zsh/.zhistory"
export HISTSIZE=10000
export KEYTIMEOUT=1
export PROMPT_EOL_MARK=""
export PROMPT_STYLE="regular"
export PS2="%B…%b "
export SAVEHIST=10000
export ZCOMPDUMP="\$XDG_CACHE_HOME/zsh/.zcompdump"
EOF

cat << EOF >> Brewfile
brew "zsh"
EOF

cat << EOF >> install.sh
install-file "\$HOME/.zshenv" "$module/.zshenv"
install-file "\$XDG_CONFIG_HOME/zsh" "$module/config"
EOF
