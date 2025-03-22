package main

import (
	"flag"
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

type Command struct {
	Name   CommandName
	Params any
}

type CommandName string

const (
	CommandNameAlias       CommandName = "alias"
	CommandNameBrewCask    CommandName = "brew-cask"
	CommandNameBrewFormula CommandName = "brew-formula"
	CommandNameDefault     CommandName = "default"
	CommandNameEnv         CommandName = "env"
	CommandNameFile        CommandName = "file"
	CommandNameMas         CommandName = "mas"
	CommandNameRun         CommandName = "run"
	CommandNameRunSudo     CommandName = "run-sudo"
)

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

	commandsFromModule := make(map[string][]Command, len(modules))
	for name, module := range modules {
		for _, params := range module.Alias {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameAlias, Params: params})
		}
		for _, params := range module.BrewCask {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameBrewCask, Params: params})
		}
		for _, params := range module.BrewFormula {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameBrewFormula, Params: params})
		}
		for _, params := range module.Default {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameDefault, Params: params})
		}
		for _, params := range module.Env {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameEnv, Params: params})
		}
		for _, params := range module.File {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameFile, Params: params})
		}
		for _, params := range module.Mas {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameMas, Params: params})
		}
		for _, params := range module.Run {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameRun, Params: params})
		}
		for _, params := range module.RunSudo {
			commandsFromModule[name] = append(commandsFromModule[name], Command{Name: CommandNameRunSudo, Params: params})
		}
	}
}
