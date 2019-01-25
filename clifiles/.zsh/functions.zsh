# ---------------------------------------------------------------------------- #
# Navigation
# ---------------------------------------------------------------------------- #


# makes a directory and changes to it
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

# cds into specified repository located under $REPOSITORIES
function repo {
	cd "$REPOSITORIES/$1"
}
compctl -/ -W "$REPOSITORIES" repo

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

# makes Python virtual environment (supports Python 3 only)
function makevenv {
	if [[ -n "$1" ]]; then
		python -m venv "$1"
	else
		python -m venv ./venv
	fi
}

# activates Python virtual environment
function actvenv {
	if [[ -n "$1" ]]; then
		source "$1/bin/activate"
	else
		source ./venv/bin/activate
	fi
}


# ---------------------------------------------------------------------------- #
# Utilties
# ---------------------------------------------------------------------------- #


# sources .zshrc file
function reload {
	source "$ZDOTDIR/.zshrc"
}
