package brew

import (
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
)

// Apply.
// packages must not contain duplicates.
func Apply(packages []string, stdout io.Writer) error {
	logPath := "brew.log"
	if _, err := os.Stat(logPath); !errors.Is(err, os.ErrNotExist) {
		return fmt.Errorf("file exists: %s", logPath)
	}

	logFile, err := os.Create(logPath)
	if err != nil {
		return err
	}
	defer logFile.Close()

	fmt.Fprintf(stdout, "installing %d packages\n", len(packages))

	brewUpdate := exec.Command("brew", "update")
	brewUpdate.Stdout = logFile
	brewUpdate.Stderr = logFile
	fmt.Fprint(stdout, "updating the package repository\n")
	fmt.Fprintf(logFile, "$ %s\n", brewUpdate)
	if err := brewUpdate.Run(); err != nil {
		var exitErr *exec.ExitError
		if errors.As(err, &exitErr) {
			fmt.Fprintf(logFile, "exit code %d\n", exitErr.ExitCode())
		}
		fmt.Fprint(stdout, "failed to update the repository\n")
		return err
	}

	success := 0
	failure := 0

	for _, p := range packages {
		fmt.Fprintf(stdout, "installing %s\n", p)

		brewInstall := exec.Command("brew", "install", p)

		brewInstall.Env = os.Environ()
		// prevents brew install from automatically running brew update
		brewInstall.Env = append(brewInstall.Env, "HOMEBREW_NO_AUTO_UPDATE=1")
		// prevents brew install from automatically running brew cleanup for just installed packages and sometimes all packages
		brewInstall.Env = append(brewInstall.Env, "HOMEBREW_NO_INSTALL_CLEANUP=1")
		// prevents brew install from automatically running brew upgrade for already installed packages
		brewInstall.Env = append(brewInstall.Env, "HOMEBREW_NO_INSTALL_UPGRADE=1")

		brewInstall.Stdout = logFile
		brewInstall.Stderr = logFile

		fmt.Fprintf(logFile, "$ %s\n", brewInstall)
		if err := brewInstall.Run(); err != nil {
			var exitErr *exec.ExitError
			if errors.As(err, &exitErr) {
				fmt.Fprintf(logFile, "exit code %d\n", exitErr.ExitCode())
			}
			fmt.Fprintf(stdout, "failed to install %s\n", p)
			failure++
			continue
		}

		// // TODO: Consider running brew cleanup for just installed packages.
		// // It also seems like brew install runs it all the time regardless of whether it was or wasn't installed before.
		// // However, the brew cleanup documentation makes it sound like it affects only packages that were installed before.
		// // Also consider that when install succeeds but cleanup fails,
		// // the whole installation is failed even though the package is installed.
		// brewCleanup := exec.Command("brew", "cleanup", p)
		// brewCleanup.Stdout = logFile
		// brewCleanup.Stderr = logFile
		//
		// fmt.Fprintf(logFile, "$ %s\n", brewCleanup)
		// if err := brewCleanup.Run(); err != nil {
		// 	var exitErr *exec.ExitError
		// 	if errors.As(err, exitErr) {
		// 		fmt.Fprintf(logFile, "exit code %d\n", exitErr.ExitCode())
		// 	}
		// 	fmt.Fprintf(stdout, "failed to clean up %s\n", p)
		// 	failure++
		// 	continue
		// }

		success++
	}

	fmt.Fprintf(stdout, "installed %d/%d packages\n", success, len(packages))
	if failure > 0 {
		return fmt.Errorf("failed to install %d packages", failure)
	}
	return nil
}
