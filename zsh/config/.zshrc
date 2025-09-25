source "$HOME/.zshrc"

function dotfiles-setup() {
    "$HOME/Repositories/dotfiles/$1/setup.sh"
}
_dotfiles-setup() {
  _files -/ -W "$HOME/Repositories/dotfiles"
}
compdef _dotfiles-setup dotfiles-setup
