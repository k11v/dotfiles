PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/bin:$PATH"
PATH="/opt/homebrew/sbin:$PATH"

for f in "$HOME"/.local/share/zsh/integration/*.zsh(N); do
	source "$f"
done
