# Dotfiles

Files that start with a dot.

## Installation

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

### 2. Bundle Brewfile

```sh
git clone https://github.com/kirillgashkov/dotfiles.git ~/.dotfiles
brew bundle --file ~/.dotfiles/Brewfile
```

### 3. Setup Dotfiles

```sh
cd ~/.dotfiles
sh ./bootstrap.sh
zsh
```

### 4. Setup system

<details>
  <summary><i>Tweak dock's settings</i></summary>

  ```sh
  # Speed up the dock's hiding animation (delete this key to revert)
  defaults write com.apple.dock autohide-time-modifier -float 0.7
  # Speed up the dock's autohide delay (delete this key to revert)
  defaults write com.apple.dock autohide-delay -float 0.2
  # Apply changes
  killall Dock
  ```
</details>

<details>
  <summary><i>Show hidden files</i></summary>

  ```sh
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
  ```
</details>

### 5. Setup apps

#### Built-in

<details>
  <summary><i>Finder</i></summary>

  - Visibility
    - Make `~/Library` visible
    - Make hidden files visible
  - Extensions
    - Make extensions visible
    - Suppress warnings when changing extensions
  - Miscellaneous
    - Make new tabs start at `~/`
    - Enable snap to grid
</details>

<details>
  <summary><i>Safari</i></summary>

  - Show `Develop` menu
</details>

#### External

<details>
  <summary><i>iTerm</i></summary>

  - Turn on custom folder preferences
</details>

<details>
  <summary><i>Sublime Text</i></summary>

  - Copy settings to `User`
  - Install package control
  - Install packages:
    - PlistBinary
  - Copy to `User` [Russian-English Bilingual](https://github.com/titoBouzout/Dictionaries) dictionary (`.aff` and `.dic`).
</details>

<details>
  <summary><i>Xcode</i></summary>

  - Add developer account
  - Set ruler at 80 characters
  - Disable source control
</details>

<details>
  <summary><i>Karabiner</i></summary>

  - Copy complex modifications to config folder
  - Enable Caps Lock to switch languages
</details>

### 6. Setup SSH

#### Generating a new SSH key

> [Generating a new SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

#### Add SSH key to GitHub account

> [Add SSH key to GitHub account](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

Start with copying the public key.

```sh
pbcopy < ~/.ssh/id_rsa.pub
```

Continue with opening settings of your GitHub account and pasting the key there.

## License

Distributed under the MIT License. See the [LICENSE.md](LICENSE.md) for details.

## Acknowledgments

- [ptb's dotfiles](https://github.com/ptb/mac-setup)
- [kevinSuttle's dotfiles](https://github.com/kevinSuttle/dotfiles)
- [mathiasbynens's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [caarlos0's dotfiles](https://github.com/caarlos0/dotfiles)
