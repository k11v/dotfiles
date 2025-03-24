# Dotfiles

1. Install _your_ SSH key (to be able to clone _your_ Dotfiles repository):

   ```sh
   mkdir -p "$HOME/.ssh"
   cp /path/to/your/key "$HOME/.ssh"
   chmod 0400 "$HOME/.ssh/key"
   ```

2. Install Xcode Command Line Tools (to get Git): <!-- TODO: Consider curl installation. -->

   ```sh
   xcode-select --install
   ```

3. Install Dot: <!-- TODO: Consider curl installation. -->

   ```sh
   mkdir -p "$HOME/.local/bin"
   curl -sSL https://github.com/k11v/dotfiles/releases/latest/download/dot-darwin_arm64.tar.gz | tar xz -C "$HOME/.local/bin"
   export PATH="$HOME/.local/bin:$PATH"
   ```

4. Clone the Dotfiles repository:

   ```sh
   mkdir -p "$HOME/Repositories"
   git clone git@github.com:k11v/dotfiles.git "$HOME/Repositories/dotfiles"
   ```

5. Run the setup (via caffeinate to prevent Mac from sleeping):

   ```sh
   cd "$HOME/Repositories/dotfiles"
   caffeinate -d dot setup ./brew ./mas ./...
   ```
