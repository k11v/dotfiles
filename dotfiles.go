package dotfiles

import "os/exec"

type Brewer interface {
	Brew(p string) error
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
