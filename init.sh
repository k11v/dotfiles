for module in *; do
    [ "$INSTALL" -eq 1 ] && printf "%b%s%b%b%s%b\n" "\e[1;35m" "Installing" "\e[0m" "\e[1m" " $module" "\e[0m"
    source "$module"
done
