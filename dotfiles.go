package dotfiles

import "os/exec"

type Brewer interface {
	BrewFormula(p string) error
	BrewCask(p string) error
}

type Enver interface {
	Env(k, v string)
}

type Filer interface {
	File(dst, src string)
}

type Runner interface {
	Run(c *exec.Cmd)
}
