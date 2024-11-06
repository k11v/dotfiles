package main

import (
	"fmt"
	"io"
	"os"

	"github.com/goccy/go-yaml"
	"github.com/google/shlex"
)

type Module struct {
	Env  []Args `yaml:"env"`
	Brew []Args `yaml:"brew"`
	Run  []Args `yaml:"run"`
	Link []Args `yaml:"link"`
}

type Args []string

func (args *Args) UnmarshalText(text []byte) error {
	splitArgs, err := shlex.Split(string(text))
	if err != nil {
		return err
	}
	*args = append(*args, splitArgs...)
	return nil
}

func main() {
	if err := run(os.Args, os.Stdin, os.Stdout, os.Stderr); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	os.Exit(0)
}

func run(args []string, stdin io.Reader, stdout io.Writer, stderr io.Writer) error {
	moduleFile := stdin

	var module Module
	dec := yaml.NewDecoder(moduleFile, yaml.DisallowUnknownField())
	if err := dec.Decode(&module); err != nil {
		return err
	}

	fmt.Fprintf(stdout, "%#v", module)

	return nil
}
