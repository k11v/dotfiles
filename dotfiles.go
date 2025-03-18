package dotfiles

import (
	"io/fs"
	"os/exec"
)

type Brewer interface {
	BrewFormula(p string) error
	BrewCask(p string) error
}

type Maser interface {
	Mas(p string) error
}

type Defaulter interface {
	// float, int
	// -array "one" "two"
	// -dict 0 -string "." 1 -string "," 10 -string "." 17 -string ","
	// -int 1
	// -bool false
	// -bool true
	// -int 2
	// -int 2
	Default(domain string, k string, v any) error
}

type Enver interface {
	Env(k, v string) error
}

type Filer interface {
	File(dst, src string, srcFS fs.FS) error
}

type Runner interface {
	Run(c *exec.Cmd) error
}
