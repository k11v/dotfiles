package dotfiles

import "os/exec"

type Brewer struct{}

func (b *Brewer) Brew(p string) error {
	return nil
}

type Enver struct{}

func (e *Enver) Env(k, v string) error {
	return nil
}

type Filer struct{}

func (f *Filer) File(dst, src string) error {
	return nil
}

type Runner struct{}

func (e *Runner) Run(c *exec.Cmd) error {
	return nil
}
