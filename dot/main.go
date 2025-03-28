package main

import (
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"slices"
	"strings"

	"github.com/goccy/go-yaml"
)

func main() {
	flag.Parse()

	if flag.NArg() < 1 {
		_, _ = fmt.Fprint(os.Stderr, "error: missing command arg\n")
		os.Exit(1)
	}

	command := flag.Arg(0)
	if command != "setup" {
		_, _ = fmt.Fprintf(os.Stderr, "error: unknown command arg: %s\n", command)
		os.Exit(1)
	}

	patterns := flag.Args()[1:]

	dataDir, err := DataDir()
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: data dir: %v\n", err)
		os.Exit(1)
	}

	mods, err := SearchMods(patterns)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: can't search mods: %v\n", err)
		os.Exit(1)
	}

	declsFromMod, err := LoadMods(mods)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: can't load mods: %v\n", err)
		os.Exit(1)
	}

	envFile := filepath.Join(dataDir, "env.sh")
	setupper := NewSetupper(envFile)
	err = SetupMods(setupper, mods, declsFromMod)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: can't setup mods: %v\n", err)
		os.Exit(1)
	}
}

func SearchMods(patterns []string) ([]string, error) {
	mods := make([]string, 0)

	q := slices.Clone(patterns)
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
					return errors.New("want 1 key in decl map")
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
					domain := args[0].(string)
					key := args[1].(string)
					value := args[2]
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
			return nil, err
		}
	}

	return declsFromMod, nil
}

func SetupMods(setupper *Setupper, mods []string, declsFromMod map[string][]Decl) error {
	for mi, mod := range mods {
		fmt.Printf("=== %s (%d/%d)\n", mod, mi, len(mods))
		decls := declsFromMod[mod]
	DeclLoop:
		for di, decl := range decls {
			fmt.Printf("--- %T (%d/%d)\n", decl, di, len(decls))
			var err error
			switch d := decl.(type) {
			case BrewCask:
				err = setupper.SetupBrewCask(d)
			case BrewFormula:
				err = setupper.SetupBrewFormula(d)
			case Default:
				err = setupper.SetupDefault(d)
			case EnvAlias:
				err = setupper.SetupEnvAlias(d)
			case EnvVar:
				err = setupper.SetupEnvVar(d)
			case Link:
				err = setupper.SetupLink(d)
			case Mas:
				err = setupper.SetupMas(d)
			case Run:
				err = setupper.SetupRun(d)
			default:
				err = errors.New("unknown decl type")
			}
			if err != nil {
				_, _ = fmt.Fprintf(os.Stderr, "error: can't setup %T: %v\n", decl, err)
				break DeclLoop
			}
		}
	}
	return nil
}

func DataDir() (string, error) {
	userDataDir := os.Getenv("XDG_DATA_HOME")
	if userDataDir == "" {
		userHomeDir, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		userDataDir = filepath.Join(userHomeDir, ".local", "share")
	}

	return filepath.Join(userDataDir, "dot"), nil
}
