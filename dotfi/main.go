package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
)

type Decl struct {
	Type string
	Args []string
}

func main() {
	flag.Parse()

	// Provided via args.
	// Specified as paths to directories containing dot.yaml files.
	// Direct paths to dot.yaml files are not resolved.
	// "path/to/..." resolves to all nested modules discovered by the presence of dot.yaml file.
	// Avoid naming configuration files as dot.yaml since ignoring false positives is not supported.
	mods := []string{
		"alacritty",
		"hammerspoon",
		"safari",
		"tldr",
	}

	// Loaded from */dot.yaml files.
	declsFromMod := map[string][]Decl{
		"alacritty": {
			{Type: "brew-cask", Args: []string{"alacritty"}},
			{Type: "link", Args: []string{"$XDG_CONFIG_HOME/alacritty", "config"}},
		},
		"hammerspoon": {
			{Type: "brew-cask", Args: []string{"hammerspoon"}},
			{Type: "link", Args: []string{"$XDG_CONFIG_HOME/hammerspoon", "config"}},
			{Type: "default", Args: []string{"org.hammerspoon.Hammerspoon", "MJConfigFile", "$XDG_CONFIG_HOME/hammerspoon/init.lua"}},
			{Type: "default", Args: []string{"org.hammerspoon.Hammerspoon", "MJShowDockIconKey", "-bool", "false"}},
			{Type: "default", Args: []string{"org.hammerspoon.Hammerspoon", "MJShowMenuIconKey", "-bool", "false"}},
		},
		"safari": {
			{Type: "default", Args: []string{"com.apple.Safari", "IncludeDevelopMenu", "-bool", "true"}},
		},
		"tldr": {
			{Type: "env", Args: []string{"TEALDEER_CONFIG_DIR", "$XDG_CONFIG_HOME/tealdeer"}},
			{Type: "brew-formula", Args: []string{"tealdeer"}},
			{Type: "link", Args: []string{"$XDG_CONFIG_HOME/tealdeer", "config"}},
			{Type: "run", Args: []string{"tldr --update"}},
		},
	}

ModLoop:
	for modIndex, mod := range mods {
		decls := declsFromMod[mod]
		for declIndex, decl := range decls {
			_, _ = fmt.Printf("[%d/%d] %s\t[%d/%d] %s\n", modIndex+1, len(mods), mod, declIndex+1, len(decls), decl)

			switch decl.Type {
			case "brew-cask":
				p := decl.Args[0]
				if len(decl.Args) > 1 {
					panic("extra args")
				}

				// TODO: Check what happens when brew needs stdin and stdin is not attached.
				// TODO: Change command to not use stdin.
				c := exec.Command("brew", "install", "--cask", p)
				// c.Stdin = os.Stdin
				c.Stdout = os.Stdout
				c.Stderr = os.Stderr

				err := c.Run()
				if err != nil {
					var exitErr *exec.ExitError
					if errors.As(err, &exitErr) {
						_, _ = fmt.Printf("[%d/%d] %s\t[%d/%d] %s\t[!] ERROR\n", modIndex+1, len(mods), mod, declIndex+1, len(decls), decl)
						continue ModLoop
					}
				}
			case "brew-formula":
				p := decl.Args[0]
				if len(decl.Args) > 1 {
					panic("extra args")
				}

				// TODO: Check what happens when brew needs stdin and stdin is not attached.
				// TODO: Change command to not use stdin.
				c := exec.Command("brew", "install", "--formula", p)
				// c.Stdin = os.Stdin
				c.Stdout = os.Stdout
				c.Stderr = os.Stderr

				err := c.Run()
				if err != nil {
					var exitErr *exec.ExitError
					if errors.As(err, &exitErr) {
						_, _ = fmt.Printf("[%d/%d] %s\t[%d/%d] %s\t[!] ERROR\n", modIndex+1, len(mods), mod, declIndex+1, len(decls), decl)
						continue ModLoop
					}
				}
			case "link":
			case "default":
			case "env":
			case "run":
			default:
				panic("unknown decl type")
			}
		}
	}
}
