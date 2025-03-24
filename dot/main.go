package main

import (
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"

	"github.com/goccy/go-yaml"
)

func SearchMods(patterns []string) ([]string, error) {
	mods := make([]string, 0)

	q := append([]string(nil), patterns...)
	for len(q) > 0 {
		var p string
		p, q = q[0], q[1:]

		i := strings.Index(p, "...")
		if i != -1 {
			if i+len("...") < len(p) {
				return nil, errors.New(`pattern has characters after "..."`)
			}

			dir, file := filepath.Split(p[:i])
			if file != "" {
				return nil, errors.New(`pattern has "..." in file name`)
			}

			if dir == "" {
				dir = "." + string(filepath.Separator)
			}

			// FIXME: Likely fails if dir is not a directory.
			entries, err := os.ReadDir(dir)
			if err != nil {
				return nil, err
			}

			q = append(q, dir)
			for _, entry := range entries {
				q = append(q, dir+entry.Name()+"/...")
			}

			continue
		}

		pfi, err := os.Stat(p)
		if err != nil {
			return nil, err
		}
		if !pfi.IsDir() {
			continue
		}

		mfi, err := os.Stat(filepath.Join(p, "dot.yaml"))
		if err != nil {
			if errors.Is(err, os.ErrNotExist) {
				continue
			}
			return nil, err
		}
		if mfi.IsDir() {
			return nil, errors.New("dot.yaml is a directory")
		}

		mod := strings.TrimRight(p, string(filepath.Separator))
		mods = append(mods, mod)
	}

	return mods, nil
}

func LoadMods(mods []string) (map[string][]Decl, error) {
	declsFromMod := make(map[string][]Decl)

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

			var declMaps []map[string][]any
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
				var args []any
				for key := range declMap {
					typ = key
				}
				args = declMap[typ]

				var decl Decl
				switch typ {
				case "brew-cask":
					if len(args) != 1 {
						return fmt.Errorf("%s: want 1 argument", "brew-cask")
					}
					name := args[0].(string)
					decl = BrewCask{Name: name}
				case "brew-formula":
					if len(args) != 1 {
						return fmt.Errorf("%s: want 1 argument", "brew-formula")
					}
					name := args[0].(string)
					decl = BrewFormula{Name: name}
				case "default":
					if len(args) != 3 {
						return fmt.Errorf("%s: want 3 arguments", "default")
					}
					domain := args[1].(string)
					key := args[2].(string)
					value := args[3]
					decl = Default{Domain: domain, Key: key, Value: value}
				case "env-alias":
					if len(args) != 2 {
						return fmt.Errorf("%s: want 2 arguments", "env-alias")
					}
					key := args[0].(string)
					value := args[1].(string)
					decl = EnvAlias{Key: key, Value: value}
				case "env-var":
					if len(args) != 2 {
						return fmt.Errorf("%s: want 2 arguments", "env-var")
					}
					key := args[0].(string)
					value := args[1].(string)
					decl = EnvVar{Key: key, Value: value}
				case "link":
					if len(args) != 2 {
						return fmt.Errorf("%s: want 2 arguments", "link")
					}
					dst := args[0].(string)
					src := args[1].(string)
					decl = Link{Dst: dst, Src: src}
				case "mas":
					if len(args) != 1 {
						return fmt.Errorf("%s: want 1 argument", "mas")
					}
					id := args[0].(string)
					decl = Mas{ID: id}
				case "run":
					if len(args) != 1 {
						return fmt.Errorf("%s: want 1 argument", "run")
					}
					command := args[0].(string)
					decl = Run{Command: command}
				default:
					return fmt.Errorf("unknown decl type: %s", typ)
				}

				decls = append(decls, decl)
			}

			declsFromMod[mod] = decls
			return nil
		}()
		if err != nil {
			_, _ = fmt.Fprintf(os.Stderr, "error: %v\n", err)
			os.Exit(1)
		}
	}

	return declsFromMod, nil
}

func main() {
	flag.Parse()

	mods, err := SearchMods(flag.Args())
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	declsFromMod, err := LoadMods(mods)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

ModLoop:
	for modIndex, mod := range mods {
		decls := declsFromMod[mod]
		for declIndex, decl := range decls {
			_, _ = fmt.Printf("[%d/%d] %s\t[%d/%d] %s\n", modIndex+1, len(mods), mod, declIndex+1, len(decls), decl)

			switch decl.Type {
			case "brew-cask":
			case "brew-formula":
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
