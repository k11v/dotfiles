package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
)

var errFlagParse = errors.New("failed flag parse")

func main() {
	if err := run(os.Args, os.Stdout, os.Stderr); err != nil {
		if !errors.Is(err, errFlagParse) {
			fmt.Fprintf(os.Stderr, "error: %v\n", err)
		}
		os.Exit(1)
	}
	os.Exit(0)
}

func run(args []string, stdout io.Writer, stderr io.Writer) error {
	fs := flag.NewFlagSet(args[0], flag.ContinueOnError)
	fs.SetOutput(stderr)

	if err := fs.Parse(args[1:]); err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return nil
		}
		return errors.Join(errFlagParse, err)
	}

	return nil
}
