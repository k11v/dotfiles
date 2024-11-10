# VSCode

## Install

```sh
mkdir -p "$HOME/Library/Application Support/Code"
ln -s "$PWD/User" "$HOME/Library/Application Support/Code"
```

## Manage

```sh
# dump current extensions
code --list-extensions | sort > extensions.txt

# uninstall extra extensions
code --list-extensions | sort | comm -23 - extensions.txt | xargs -n1 code --uninstall-extension

# install missing extensions
code --list-extensions | sort | comm -13 - extensions.txt | xargs -n1 code --install-extension
```

## LIKELY uninstall

```sh
# Remove user config and data.
rm -rf "$HOME/.vscode/extensions"
rm -rf "$HOME/Library/Application Support/Code/User"
```

```sh
# OR remove even more.
rm -rf "$HOME/.vscode"
rm -rf "$HOME/Library/Application Support/Code"
```

## Referneces

See https://anhari.dev/blog/saving-vscode-settings-in-your-dotfiles.
