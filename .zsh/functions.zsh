# ---------------------------------------------------------------------------- #
# Navigation
# ---------------------------------------------------------------------------- #


# makes a directory and changes to it
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

# cds into the forefront Finder window
function cdf {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}


# ---------------------------------------------------------------------------- #
# Development
# ---------------------------------------------------------------------------- #


# cleans Xcode's derived data
function cleandd {
	rm -rf ~/Library/Developer/Xcode/DerivedData
}


# ---------------------------------------------------------------------------- #
# Utilties
# ---------------------------------------------------------------------------- #


# sources .zshrc file
function reload {
	source "$ZDOTDIR/.zshrc"
}
