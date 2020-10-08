#
# Navigation
#


# Make a directory and cd to it
function mcd {
	[[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

# Cd into the forefront Finder window
function cdf {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Cd into specified repository located under $LOCAL_DEV
function dev {
	cd "$LOCAL_DEV/$1"
}
compctl -/ -W "$LOCAL_DEV" dev

# Cd into specified repository located under $LOCAL_EDU
function edu {
	cd "$LOCAL_EDU/$1"
}
compctl -/ -W "$LOCAL_EDU" edu

# Cd into specified repository located under $LOCAL_WORK
function work {
	cd "$LOCAL_WORK/$1"
}
compctl -/ -W "$LOCAL_WORK" work


#
# Development
#


# Clean Xcode's derived data
function cleandd {
	rm -rf ~/Library/Developer/Xcode/DerivedData
}


#
# Utilties
#


# Source .zshrc file
function reload {
	source "$ZDOTDIR/.zshrc"
}
