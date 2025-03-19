package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/pelletier/go-toml/v2"
)

type Module struct {
	Alias       [][]any
	BrewCask    [][]any
	BrewFormula [][]any
	Default     [][]any
	Env         [][]any
	File        [][]any
	Mas         [][]any
	Run         [][]any
	RunSudo     [][]any
}

func main() {
	flag.Parse()

	moduleFiles := flag.Args()
	modules := make(map[string]*Module, len(moduleFiles))

	for _, moduleFile := range moduleFiles {
		err := func() error {
			modules[moduleFile] = new(Module)

			f, err := os.Open(moduleFile)
			if err != nil {
				return err
			}

			dec := toml.NewDecoder(f)
			dec.DisallowUnknownFields()
			err = dec.Decode(modules[moduleFile])
			if err != nil {
				return err
			}

			return nil
		}()
		if err != nil {
			panic(err)
		}
	}

	for name, module := range modules {
		fmt.Printf("%q = %#v\n", name, module)
	}
}
