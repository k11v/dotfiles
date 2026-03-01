# Dotfiles

Dotfiles contains configuration files for programs that I use on a daily basis and a tool to install them on my personal computer.

## Install

```sh
xcode-select --install
```

```sh
mkdir -p "$HOME/.ssh"
cp /path/to/your/key "$HOME/.ssh"
chmod 0400 "$HOME/.ssh/key"
```

```sh
mkdir -p "$HOME/Repositories"
git clone git@github.com:k11v/dotfiles.git "$HOME/Repositories/dotfiles"
```

```sh
dotfiles="$HOME/Repositories/dotfiles/dot/.bin/dot"
caffeinate -d "$dotfiles" "$HOME"/Repositories/dotfiles/*
```
