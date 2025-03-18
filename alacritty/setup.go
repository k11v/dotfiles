package alacritty

import (
	"embed"

	"github.com/k11v/dotfiles"
)

//go:embed config
var fsys embed.FS

func Setup(brewer dotfiles.Brewer, filer dotfiles.Filer) error {
	err := brewer.BrewCask("alacritty")
	if err != nil {
		return err
	}
	err = filer.File("$XDG_CONFIG_HOME/alacritty", "config", fsys)
	if err != nil {
		return err
	}
	return nil
}
