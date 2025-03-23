package main

import (
	"bytes"
	"encoding/hex"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

// TODO: Add variable expansion (e.g. "$XDG_CONFIG_HOME").

type Setupper struct {
	envFile string
}

func (s *Setupper) SetupBrewCask(d BrewCask) error {
	c := exec.Command("brew", "install", "--cask", "--", d.Name)
	c.Stdin = os.Stdin // TODO: Change to not use stdin.
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	return c.Run()
}

func (s *Setupper) SetupBrewFormula(d BrewFormula) error {
	c := exec.Command("brew", "install", "--formula", "--", d.Name)
	c.Stdin = os.Stdin // TODO: Change to not use stdin.
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	return c.Run()
}

func (s *Setupper) SetupDefault(d Default) error {
	args := make([]string, 0)

	if d.Value != nil {
		args = append(args, "defaults", "write", d.Domain, d.Key)
		switch value := d.Value.(type) {
		case string:
			args = []string{"-string", value}
		case []byte:
			args = []string{"-data", hex.EncodeToString(value)}
		case int:
			args = []string{"-int", strconv.Itoa(value)}
		case float64:
			args = []string{"-float", strconv.FormatFloat(value, 'f', -1, 64)}
		case bool:
			args = []string{"-bool", strconv.FormatBool(value)}
		case []string:
			args = append(args, "-array")
			for _, v := range value {
				args = append(args, "-string", v)
			}
		case map[string]string:
			args = append(args, "-dict")
			for k, v := range value {
				args = append(args, "-string", k, "-string", v)
			}
		default:
			return fmt.Errorf("unsupported value type: %T", value)
		}
	} else {
		args = append(args, "defaults", "delete", d.Domain, d.Key)
	}

	c := exec.Command(args[0], args[1:]...)
	c.Stdin = os.Stdin // TODO: Change to not use stdin.
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	return c.Run()
}

func (s *Setupper) SetupEnvAlias(d EnvAlias) error {
	err := os.MkdirAll(filepath.Dir(s.envFile), 0o777)
	if err != nil {
		return err
	}

	f, err := os.OpenFile(s.envFile, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0o666)
	if err != nil {
		return err
	}
	defer f.Close()

	var buf bytes.Buffer
	_, _ = buf.WriteString("alias ")
	_, _ = buf.WriteString(d.Key)
	_, _ = buf.WriteString("=")
	_, _ = buf.WriteString(escape(d.Value))
	_, _ = buf.WriteString("\n")

	_, err = io.Copy(f, &buf)
	return err
}

func (s *Setupper) SetupEnvVar(d EnvVar) error {
	err := os.MkdirAll(filepath.Dir(s.envFile), 0o777)
	if err != nil {
		return err
	}

	f, err := os.OpenFile(s.envFile, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0o666)
	if err != nil {
		return err
	}
	defer f.Close()

	var buf bytes.Buffer
	_, _ = buf.WriteString("export ")
	_, _ = buf.WriteString(d.Key)
	_, _ = buf.WriteString("=")
	_, _ = buf.WriteString(escape(d.Value))
	_, _ = buf.WriteString("\n")

	_, err = io.Copy(f, &buf)
	return err
}

func (s *Setupper) SetupLink(d Link) error {
	err := os.MkdirAll(filepath.Dir(d.Dst), 0o777)
	if err != nil {
		return err
	}
	return os.Symlink(d.Src, d.Dst)
}

func (s *Setupper) SetupMas(d Mas) error {
	c := exec.Command("mas", "install", "--", d.ID)
	c.Stdin = os.Stdin // TODO: Change to not use stdin.
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	return c.Run()
}

func (s *Setupper) SetupRun(d Run) error {
	c := exec.Command("sh", "-c", d.Command)
	c.Stdin = os.Stdin // TODO: Change to not use stdin.
	c.Stdout = os.Stdout
	c.Stderr = os.Stderr
	return c.Run()
}

func escape(arg string) string {
	return "'" + strings.ReplaceAll(arg, "'", `'\''`) + "'"
}
