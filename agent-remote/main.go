package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const (
	programName = "agent-remote"

	keychainTelegramBotToken = "telegram-bot-token"
	configTelegramChatID     = "telegramChatID"

	commandNotify = "notify"
	commandAuth   = "auth"

	authTargetTelegram = "telegram"
)

func main() {
	os.Exit(run())
}

func run() int {
	flag.Parse()
	args := flag.Args()

	if len(args) == 0 {
		fmt.Fprintf(os.Stderr, "usage: %s <command> [args...]\n", programName)
		return 1
	}

	switch args[0] {
	case commandNotify:
		return runNotify(args[1:])
	case commandAuth:
		return runAuth(args[1:])
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n", args[0])
		return 1
	}
}

func runNotify(args []string) int {
	token, err := keychainGet(keychainTelegramBotToken)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		return 1
	}

	chatID, err := configGet[string](configTelegramChatID)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		return 1
	}

	msg := "Agent needs your attention"
	if len(args) > 0 {
		msg = strings.Join(args, " ")
	}

	if err := telegramSendMessage(token, chatID, msg); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		return 1
	}

	return 0
}

func runAuth(args []string) int {
	if len(args) != 1 || args[0] != authTargetTelegram {
		fmt.Fprintf(os.Stderr, "usage: %s %s %s\n", programName, commandAuth, authTargetTelegram)
		return 1
	}

	if isInteractive() {
		fmt.Print("Token: ")
	}

	scanner := bufio.NewScanner(os.Stdin)
	if !scanner.Scan() {
		fmt.Fprintln(os.Stderr, "error: failed to read token")
		return 1
	}

	token := strings.TrimSpace(scanner.Text())
	if token == "" {
		fmt.Fprintln(os.Stderr, "error: token cannot be empty")
		return 1
	}

	if err := keychainSet(keychainTelegramBotToken, token); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		return 1
	}

	fmt.Println("Token saved to keychain.")
	return 0
}

func keychainGet(key string) (string, error) {
	out, err := exec.Command(
		"security", "find-generic-password",
		"-s", programName,
		"-a", key,
		"-w",
	).Output()
	if err != nil {
		return "", fmt.Errorf("keychain lookup %q: %w", key, err)
	}
	return strings.TrimSpace(string(out)), nil
}

func keychainSet(key, value string) error {
	_ = exec.Command(
		"security", "delete-generic-password",
		"-s", programName,
		"-a", key,
	).Run()

	err := exec.Command(
		"security", "add-generic-password",
		"-s", programName,
		"-a", key,
		"-w", value,
	).Run()
	if err != nil {
		return fmt.Errorf("keychain store %q: %w", key, err)
	}
	return nil
}

func configGet[V any](key string) (V, error) {
	var zero V

	home, err := os.UserHomeDir()
	if err != nil {
		return zero, fmt.Errorf("home dir: %w", err)
	}

	data, err := os.ReadFile(filepath.Join(home, ".config", programName, "config.json"))
	if err != nil {
		return zero, fmt.Errorf("read config: %w", err)
	}

	var cfg map[string]V
	if err := json.Unmarshal(data, &cfg); err != nil {
		return zero, fmt.Errorf("parse config: %w", err)
	}

	v, ok := cfg[key]
	if !ok {
		return zero, fmt.Errorf("config key %q not found", key)
	}

	return v, nil
}

func telegramSendMessage(token, chatID, text string) error {
	resp, err := http.PostForm(
		fmt.Sprintf("https://api.telegram.org/bot%s/sendMessage", token),
		url.Values{
			"chat_id":    {chatID},
			"text":       {text},
			"parse_mode": {"Markdown"},
		},
	)
	if err != nil {
		return fmt.Errorf("send: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("telegram responded with %d", resp.StatusCode)
	}

	return nil
}

func isInteractive() bool {
	fileInfo, _ := os.Stdin.Stat()
	return fileInfo.Mode()&os.ModeCharDevice != 0
}
