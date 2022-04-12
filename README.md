# Dotfiles

> **Note:** although it is possible to avoid cloning the repository by just
> downloading it from GitHub, it is not currently advised because some of the
> setups are not decoupled enough from the environment they are run in. It can
> cause problems later when you try replacing the "downloaded" repository with
> a "cloned" repository.

1. Show hidden files and extensions (to make this bootstrap easier).

    ```sh
    defaults write NSGlobalDomain AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
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
    mkdir -p "$HOME/Repositories"
    git clone git@github.com:kirillgashkov/dotfiles.git "$HOME/Repositories/dotfiles"
    ```

5. Run the setup script (via caffeinate to prevent Mac from sleeping).

    ```sh
    cd "$HOME/Repositories/dotfiles"
    caffeinate -d ./setup.sh
    ```
