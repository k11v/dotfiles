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

# copies pre-made gitignore (found under $GITIGNORES) to a current directory
function gitignore {
	cp "$GITIGNORES/$1" ./.gitignore
}
compctl -f -W "$GITIGNORES" gitignore

# copies pre-made readme (found under $READMES) to a current directory
function readme {
	cp "$READMES/$1" ./README.md
}
compctl -f -W "$READMES" readme

# copies pre-made license (found under $LICENSES) to a current directory
function license {
	cp "$LICENSES/$1" ./LICENSE.md
}
compctl -f -W "$LICENSES" license


# ---------------------------------------------------------------------------- #
# Utilties
# ---------------------------------------------------------------------------- #


# sources .zshrc file
function reload {
	source "$ZDOTDIR/.zshrc"
}
