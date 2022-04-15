# Dotfiles

> **Note:** although it is possible to avoid cloning the repository by just
> downloading it from GitHub, it's not currently advised to do so, because
> some of the setups are not isolated enough from the environment. It can
> cause problems later when you try replacing the "downloaded" repository
> with a "cloned" repository.

1. Show hidden files and extensions (to make this bootstrap easier).

    ```sh
    defaults write NSGlobalDomain AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    killall Finder
    ```

2. Install Xcode Command Line Tools (to get Git).

    ```sh
    xcode-select --install
    ```

3. Install *your* SSH key (to be able to clone *your* Dotfiles repository).

    ```sh
    mkdir -p "$HOME/.ssh"
    cp /path/to/your/key "$HOME/.ssh"
    ```

4. Clone the Dotfiles repository.

    ```sh
    mkdir -p "$HOME/.dotfiles"
    git clone git@github.com:kirillgashkov/dotfiles.git "$HOME/.dotfiles"
    ```

5. Run the setup script (via caffeinate to prevent Mac from sleeping).

    ```sh
    cd "$HOME/.dotfiles"
    caffeinate -d ./setup.sh
    ```
