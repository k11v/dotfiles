# Global

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$PATH"

# Pyenv

export PATH="$PYENV_ROOT/shims:$PATH"  # FIXME: 'PYENV_ROOT'

# Go

export PATH="$GOPATH/bin:$PATH"  # FIXME: 'GOPATH'

# My utils

export DOTFILES_ENVIRONMENT_LOADED=1

# Homebrew

# libpq. Not symlinked by default. Provides `pg_dump`, `psql`, etc.
export PATH="/usr/local/opt/libpq/bin:$PATH"

# mysql-client. Not symlinked by default. Provides `mysql`, etc.
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# openjdk. Not symlinked by default. Provides `java`, etc.
export PATH="/usr/local/opt/openjdk/bin:$PATH"
