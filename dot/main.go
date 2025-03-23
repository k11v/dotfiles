package main

import (
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"os/exec"

	"github.com/goccy/go-yaml"
	"github.com/google/shlex"
)

type Decl struct {
	Type string
	Args []string
}

func main() {
	flag.Parse()

	// TODO: Handle "./...".
	mods := flag.Args()

	declsFromMod := make(map[string][]Decl, len(mods))
	for _, mod := range mods {
		err := func() error {
			f, err := os.Open(mod)
			if err != nil {
				return err
			}
			defer func() {
				deferErr := f.Close()
				if deferErr != nil {
					slog.Error("didn't close file", "error", deferErr)
				}
			}()

			var declMaps []map[string]string
			dec := yaml.NewDecoder(f)
			err = dec.Decode(&declMaps)
			if err != nil {
				return err
			}

			decls := make([]Decl, 0)
			for _, declMap := range declMaps {
				if len(declMap) != 1 {
					return errors.New("decl map should have 1 key")
				}

				var typ string
				for key := range declMap {
					typ = key
				}

				args, err := shlex.Split(declMap[typ])
				if err != nil {
					return err
				}

				decls = append(decls, Decl{Type: typ, Args: args})
			}

			declsFromMod[mod] = decls

			return nil
		}()
		if err != nil {
			_, _ = fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
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
