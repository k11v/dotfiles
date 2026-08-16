# Announce cwd to the terminal via OSC 7.
# Mirrors Apple's reference implementation in /etc/zshrc_Apple_Terminal.
function _osc7() {
	emulate -L zsh
	setopt no_multibyte
	local out="" c hex
	for c in "${(s::)PWD}"; do
		if [[ "$c" == [A-Za-z0-9/._~-] ]]; then
			out+="$c"
		else
			printf -v hex '%%%02X' "'$c"
			out+="$hex"
		fi
	done
	printf '\e]7;file://%s%s\e\\' "$HOST" "$out"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _osc7
