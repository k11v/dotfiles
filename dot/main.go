package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"text/template"
)

func main() {
	os.Exit(run())
}

func run() int {
	var (
		ctx             = context.Background()
		moduleDirs      = os.Args[1:]
		moduleDirsExist = true
	)

	for _, moduleDir := range moduleDirs {
		if !fileExists(moduleDir) {
			slog.Error("module dir does not exist", "dir", moduleDir)
			moduleDirsExist = false
		}
	}
	if !moduleDirsExist {
		return 1
	}

	doXLinks(ctx, moduleDirs, "", ".home")
	doXLinks(ctx, moduleDirs, ".config", ".config")
	doXLinks(ctx, moduleDirs, ".local/bin", ".bin")
	doXLinks(ctx, moduleDirs, ".local/share/zsh/integration", ".integration/zsh")
	doXLinks(ctx, moduleDirs, ".local/share/git/integration-gitignore", ".integration/gitignore")
	doXLinks(ctx, moduleDirs, ".local/share/git/integration-gitconfig", ".integration/gitconfig")
	doXLinks(ctx, moduleDirs, ".local/share/git/integration-gitconfigopt", ".integration/gitconfigopt")
	doXLinks(ctx, moduleDirs, ".local/share/tldr/pages", ".integration/tldr")
	doConfigTmpl(ctx, moduleDirs)
	doInstallation(ctx, moduleDirs)
	doDefaults(ctx, moduleDirs)
	doBrewfile(ctx, moduleDirs)

	return 0
}

func doXLinks(_ context.Context, moduleDirs []string, relDstDir, relSrcDir string) {
	dstDir := filepath.Join(homeDir(), relDstDir)
	mkdirAll(dstDir)

	for _, moduleDir := range moduleDirs {
		srcDir := filepath.Join(moduleDir, relSrcDir)
		if !fileExists(srcDir) {
			continue
		}

		for _, srcDirEntry := range readDir(srcDir) {
			dst := filepath.Join(dstDir, srcDirEntry.Name())
			src := filepath.Join(srcDir, srcDirEntry.Name())
			slog.Info("do", "src", src)
			src = abs(src)
			if !fileExists(dst) || readlink(dst) != src {
				symlink(src, dst)
			}
		}
	}
}

func doDefaults(ctx context.Context, moduleDirs []string) {
	for _, moduleDir := range moduleDirs {
		srcFile := filepath.Join(moduleDir, ".defaults")
		if !fileExists(srcFile) {
			continue
		}

		slog.Info("do", "src", srcFile)

		output, err := exec.CommandContext(ctx, "/bin/sh", srcFile).CombinedOutput()
		if err != nil {
			slog.Error("didn't do", "src", srcFile, "output", string(output), "error", err)
			continue
		}

		slog.Info("did do", "src", srcFile, "output", string(output))
	}
}

func doInstallation(ctx context.Context, moduleDirs []string) {
	for _, moduleDir := range moduleDirs {
		srcDir := filepath.Join(moduleDir, ".installation")
		if !fileExists(srcDir) {
			continue
		}

		for _, srcDirEntry := range readDir(srcDir) {
			src := filepath.Join(srcDir, srcDirEntry.Name())
			slog.Info("do", "src", src)
			src = abs(src)
			if !executableExists(srcDirEntry.Name()) {
				cmd := exec.CommandContext(ctx, src)
				cmd.Stdin = os.Stdin
				cmd.Stdout = os.Stdout
				cmd.Stderr = os.Stderr
				if err := cmd.Run(); err != nil {
					slog.ErrorContext(ctx, "didn't do", "src", src, "error", err)
					continue
				}
				slog.ErrorContext(ctx, "did do", "src", src)
			}
		}
	}
}

func doBrewfile(ctx context.Context, moduleDirs []string) {
	for _, moduleDir := range moduleDirs {
		srcFile := filepath.Join(moduleDir, ".brewfile")
		if !fileExists(srcFile) {
			continue
		}

		slog.Info("do", "src", srcFile)

		if err := exec.CommandContext(ctx, "/usr/bin/env", "brew", "bundle", "check", "--no-upgrade", "--file", srcFile).Run(); err == nil {
			// Stop if srcFile is already installed.
			slog.Info("did do", "src", srcFile)
			continue
		}

		output, err := exec.CommandContext(ctx, "/usr/bin/env", "brew", "install", "--quiet", "--file", srcFile).CombinedOutput()
		if err != nil {
			slog.Error("didn't do", "src", srcFile, "output", string(output), "error", err)
			continue
		}

		slog.Info("did do", "src", srcFile, "output", string(output))
	}
}

func doConfigTmpl(ctx context.Context, moduleDirs []string) {
	for _, moduleDir := range moduleDirs {
		dstDir := filepath.Join(homeDir(), ".config")
		srcDir := filepath.Join(moduleDir, ".config.tmpl")
		if !fileExists(srcDir) {
			continue
		}

		slog.Info("do", "src", srcDir)

		if err := doConfigTmplModule(ctx, dstDir, srcDir); err != nil {
			slog.Error("do failed", "src", srcDir, "error", err)
			continue
		}
	}
}

func doConfigTmplModule(_ context.Context, dstDir string, srcDir string) error {
	srcDirEntries, err := os.ReadDir(srcDir)
	if err != nil {
		return err
	}

	for _, srcDirEntry := range srcDirEntries {
		dst := filepath.Join(dstDir, srcDirEntry.Name())
		src := filepath.Join(srcDir, srcDirEntry.Name())

		if exists, err := fileExistsV0(dst); err != nil {
			return err
		} else if exists {
			continue
		}

		if err = createFromTemplate(dst, src); err != nil {
			return err
		}
	}

	return nil
}

func fileExists(file string) bool {
	exists, err := fileExistsV0(file)
	if err != nil {
		slog.Error("file exists failed", "error", err)
		// Don't return.
	}
	return exists
}

func readlink(name string) string {
	result, err := os.Readlink(name)
	if err != nil {
		slog.Error("readlink failed", "error", err)
		// Don't return.
	}
	return result
}

func executableExists(name string) bool {
	if _, err := exec.LookPath(name); err != nil {
		if errors.Is(err, exec.ErrNotFound) {
			return false
		}
		panic(err)
	}
	return true
}

func abs(name string) string {
	result, err := filepath.Abs(name)
	if err != nil {
		panic(fmt.Errorf("abs failed: %w", err))
	}
	return result
}

func symlink(oldname, newname string) {
	if err := os.Symlink(oldname, newname); err != nil {
		slog.Error("link failed", "error", err)
		// Don't return.
	}
}

func mkdirAll(name string) {
	if err := os.MkdirAll(name, 0o777); err != nil {
		slog.Error("mkdir all failed", "error", err)
		// Don't return.
	}
}

func readDir(name string) []os.DirEntry {
	entries, err := os.ReadDir(name)
	if err != nil {
		slog.Error("read dir failed", "error", err)
		// Don't return.
	}
	return entries
}

func createFromTemplate(dst, src string) error {
	var (
		queue []struct {
			dst, src string
			tmpl     bool
		}
		item struct {
			dst, src string
			tmpl     bool
		}
		logger = slog.Default()
	)

	if dstWithoutTmpl, ok := strings.CutSuffix(src, ".tmpl"); ok {
		queue = append(queue, struct {
			dst, src string
			tmpl     bool
		}{dstWithoutTmpl, src, true})
	} else {
		queue = append(queue, struct {
			dst, src string
			tmpl     bool
		}{dst, src, false})
	}

	for len(queue) > 0 {
		item, queue = queue[0], queue[1:]

		if is, err := isDir(item.src); err != nil {
			return err
		} else if is {
			srcEntries, err := os.ReadDir(item.src)
			if err != nil {
				return err
			}

			for _, srcEntry := range srcEntries {
				var (
					dst  string
					tmpl bool
				)
				if name, ok := strings.CutSuffix(srcEntry.Name(), ".tmpl"); ok {
					dst = filepath.Join(item.dst, name)
					tmpl = true
				} else {
					dst = filepath.Join(item.dst, srcEntry.Name())
					tmpl = false
				}
				src := filepath.Join(item.src, srcEntry.Name())
				queue = append(queue, struct {
					dst, src string
					tmpl     bool
				}{dst, src, tmpl})
			}

			if err := os.MkdirAll(filepath.Dir(item.dst), 0o777); err != nil {
				return err
			}

			if err := os.Mkdir(item.dst, 0o777); err != nil {
				return err
			}

			logger.Info("create directory", "dst", item.dst, "src", item.src)
		} else if item.tmpl {
			err := func() error {
				if err := os.MkdirAll(filepath.Dir(item.dst), 0o777); err != nil {
					return err
				}

				dstFile, err := os.OpenFile(item.dst, os.O_RDWR|os.O_CREATE|os.O_EXCL, 0o666)
				if err != nil {
					return err
				}
				defer dstFile.Close()

				srcFile, err := os.Open(item.src)
				if err != nil {
					return err
				}
				defer srcFile.Close()

				srcData, err := io.ReadAll(srcFile)
				if err != nil {
					return err
				}

				srcFileTmpl, err := template.New("").
					Funcs(template.FuncMap{
						"homeDir": func() string {
							return homeDir()
						},
					}).
					Parse(string(srcData))
				if err != nil {
					return err
				}

				if err = srcFileTmpl.Execute(dstFile, nil); err != nil {
					return err
				}

				return nil
			}()
			if err != nil {
				return err
			}

			logger.Info("create file from template", "dst", item.dst, "src", item.src)
		} else {
			err := func() error {
				if err := os.MkdirAll(filepath.Dir(item.dst), 0o777); err != nil {
					return err
				}

				dstFile, err := os.OpenFile(item.dst, os.O_RDWR|os.O_CREATE|os.O_EXCL, 0o666)
				if err != nil {
					return err
				}
				defer dstFile.Close()

				srcFile, err := os.Open(item.src)
				if err != nil {
					return err
				}
				defer srcFile.Close()

				_, err = io.Copy(dstFile, srcFile)
				if err != nil {
					return err
				}

				return nil
			}()
			if err != nil {
				return err
			}

			logger.Info("create file from copy", "dst", item.dst, "src", item.src)
		}
	}

	return nil
}

func homeDir() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		panic(fmt.Errorf("home dir: %w", err))
	}

	return homeDir
}

func fileExistsV0(file string) (bool, error) {
	_, err := os.Stat(file)

	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}

	if err != nil {
		return false, fmt.Errorf("file exists: %w", err)
	}

	return true, nil
}

func isDir(file string) (bool, error) {
	fileInfo, err := os.Stat(file)
	if err != nil {
		return false, fmt.Errorf("is dir: %w", err)
	}

	return fileInfo.IsDir(), nil
}
