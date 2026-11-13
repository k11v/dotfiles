package main

import (
	"bytes"
	"encoding/json"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

func TestConfigFromDir(t *testing.T) {
	input, err := fixtures.ReadFile("testdata/tls/input.url")
	if err != nil {
		t.Fatal(err)
	}
	for _, test := range []struct {
		name    string
		files   map[string]string
		wantErr string
	}{
		{"proxy", map[string]string{"proxy.json": string(input)}, ""},
		{"extra tags", map[string]string{"alpha.json": string(input), "proxy.json": string(input), "zulu.json": string(input), "README": "ignored"}, ""},
		{"missing default", map[string]string{"other.json": string(input)}, "no default found"},
		{"empty link", map[string]string{"proxy.json": "\n"}, "proxy.json:"},
		{"invalid link", map[string]string{"proxy.json": "vless://private-secret@bad"}, "proxy.json:"},
		{"reserved tag", map[string]string{"direct.json": string(input), "proxy.json": string(input)}, "different from direct"},
		{"empty tag", map[string]string{".json": string(input), "proxy.json": string(input)}, "nonempty"},
	} {
		t.Run(test.name, func(t *testing.T) {
			dir := t.TempDir()
			for name, data := range test.files {
				if strings.HasSuffix(name, ".json") {
					encoded, err := json.Marshal(OutboundSpec{URL: data, Default: name == "proxy.json"})
					if err != nil {
						t.Fatal(err)
					}
					data = string(encoded)
				}
				if err := os.WriteFile(filepath.Join(dir, name), []byte(data), 0o600); err != nil {
					t.Fatal(err)
				}
			}
			if err := os.Mkdir(filepath.Join(dir, "ignored.json"), 0o700); err != nil {
				t.Fatal(err)
			}
			got, err := makeConfigFromDir(dir)
			if test.wantErr != "" {
				if err == nil || !strings.Contains(err.Error(), test.wantErr) {
					t.Fatalf("got %v, want %q", err, test.wantErr)
				}
				if strings.Contains(err.Error(), "private-secret") {
					t.Fatal("error leaked credentials")
				}
				if got != nil {
					t.Fatal("returned config on error")
				}
				return
			}
			if err != nil {
				t.Fatal(err)
			}
			if test.name == "proxy" {
				want, err := makeConfig(string(input), "proxy")
				if err != nil {
					t.Fatal(err)
				}
				if !bytes.Equal(got, want) {
					t.Fatal("directory generation changed defaults")
				}
			} else {
				var config struct {
					Outbounds []struct {
						Tag string `json:"tag"`
					} `json:"outbounds"`
				}
				if err := json.Unmarshal(got, &config); err != nil {
					t.Fatal(err)
				}
				var tags []string
				for _, outbound := range config.Outbounds {
					tags = append(tags, outbound.Tag)
				}
				if !reflect.DeepEqual(tags, []string{"proxy", "alpha", "zulu", "direct"}) {
					t.Fatalf("tags: %v", tags)
				}
			}
		})
	}
}

func TestConfigFromSymlink(t *testing.T) {
	dir := t.TempDir()
	input, err := fixtures.ReadFile("testdata/tls/input.url")
	if err != nil {
		t.Fatal(err)
	}
	source := filepath.Join(t.TempDir(), "private.json")
	data, err := json.Marshal(OutboundSpec{URL: string(input), Default: true})
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(source, data, 0o600); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(source, filepath.Join(dir, "proxy.json")); err != nil {
		t.Fatal(err)
	}
	if _, err := makeConfigFromDir(dir); err != nil {
		t.Fatal(err)
	}
}

func TestWriteConfig(t *testing.T) {
	// macOS temp directories can be reached through /var, itself a symlink.
	dir, err := filepath.EvalSymlinks(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	output := filepath.Join(dir, "xray", "config.json")
	for _, content := range []string{"first", "replacement"} {
		if err := writeConfig(output, []byte(content)); err != nil {
			t.Fatal(err)
		}
		got, err := os.ReadFile(output)
		if err != nil {
			t.Fatal(err)
		}
		if string(got) != content {
			t.Fatalf("content: %s", got)
		}
		info, err := os.Stat(output)
		if err != nil {
			t.Fatal(err)
		}
		if info.Mode().Perm() != 0o600 {
			t.Fatalf("permissions: %v", info.Mode())
		}
	}
	for _, link := range []string{filepath.Join(dir, "config.json"), filepath.Join(dir, "linked-dir")} {
		target := output
		destination := link
		if filepath.Base(link) == "linked-dir" {
			target = filepath.Dir(output)
			destination = filepath.Join(link, "config.json")
		}
		if err := os.Symlink(target, link); err != nil {
			t.Fatal(err)
		}
		if err := writeConfig(destination, []byte("secret")); err == nil {
			t.Fatal("allowed symlink output")
		}
	}
	got, err := os.ReadFile(output)
	if err != nil {
		t.Fatal(err)
	}
	if string(got) != "replacement" {
		t.Fatal("symlink target modified")
	}
}

func TestJSONChains(t *testing.T) {
	input, err := fixtures.ReadFile("testdata/tls/input.url")
	if err != nil {
		t.Fatal(err)
	}
	for _, test := range []struct {
		name    string
		via     map[string]string
		raw     string
		wantErr string
	}{
		{name: "chain", via: map[string]string{"proxy": "entry", "entry": "first", "first": ""}},
		{name: "missing", via: map[string]string{"proxy": "missing"}, wantErr: "existing outbound"},
		{name: "self", via: map[string]string{"proxy": "proxy"}, wantErr: "cycle"},
		{name: "cycle", via: map[string]string{"proxy": "entry", "entry": "proxy"}, wantErr: "cycle"},
		{name: "unused cycle", via: map[string]string{"proxy": "", "other": "other"}, wantErr: "cycle"},
		{name: "malformed", raw: `{"url":"private-secret`, wantErr: "JSON object"},
		{name: "unknown field", raw: `{"url":"private-secret", "vla":"entry"}`, wantErr: "JSON object"},
		{name: "wrong type", raw: `{"url":123}`, wantErr: "JSON object"},
		{name: "trailing object", raw: `{} {}`, wantErr: "one JSON object"},
		{name: "null", raw: `null`, wantErr: "vless://"},
	} {
		t.Run(test.name, func(t *testing.T) {
			dir := t.TempDir()
			for tag, via := range test.via {
				data, err := json.Marshal(OutboundSpec{URL: string(input), Via: via, Default: tag == "proxy"})
				if err != nil {
					t.Fatal(err)
				}
				if err := os.WriteFile(filepath.Join(dir, tag+".json"), data, 0o600); err != nil {
					t.Fatal(err)
				}
			}
			if test.raw != "" {
				if err := os.WriteFile(filepath.Join(dir, "proxy.json"), []byte(test.raw), 0o600); err != nil {
					t.Fatal(err)
				}
			}
			got, err := makeConfigFromDir(dir)
			if test.wantErr != "" {
				if err == nil || !strings.Contains(err.Error(), test.wantErr) {
					t.Fatalf("got %v, want %s", err, test.wantErr)
				}
				if strings.Contains(err.Error(), "private-secret") {
					t.Fatal("leaked credentials")
				}
				if got != nil {
					t.Fatal("returned config on error")
				}
				return
			}
			if err != nil {
				t.Fatal(err)
			}
			var config struct {
				Outbounds []struct {
					Tag    string `json:"tag"`
					Stream struct {
						Sockopt struct {
							Via string `json:"dialerProxy"`
						} `json:"sockopt"`
					} `json:"streamSettings"`
				} `json:"outbounds"`
			}
			if err := json.Unmarshal(got, &config); err != nil {
				t.Fatal(err)
			}
			for _, outbound := range config.Outbounds {
				if outbound.Stream.Sockopt.Via != test.via[outbound.Tag] {
					t.Fatalf("wrong chain for %s", outbound.Tag)
				}
			}
			if config.Outbounds[0].Tag != "proxy" {
				t.Fatal("proxy must remain first")
			}
		})
	}
}

func TestDefaultOutbound(t *testing.T) {
	input, err := fixtures.ReadFile("testdata/tls/input.url")
	if err != nil {
		t.Fatal(err)
	}
	for _, test := range []struct {
		name     string
		defaults map[string]bool
		want     string
		wantErr  string
	}{
		{name: "custom default with chain", defaults: map[string]bool{"entry": false, "exit": true, "proxy": false}, want: "exit"},
		{name: "empty directory", wantErr: "no default found"},
		{name: "none selected", defaults: map[string]bool{"proxy": false}, wantErr: "no default found"},
		{name: "multiple selected", defaults: map[string]bool{"entry": true, "exit": true}, wantErr: "multiple defaults found"},
	} {
		t.Run(test.name, func(t *testing.T) {
			dir := t.TempDir()
			for tag, selected := range test.defaults {
				spec := OutboundSpec{URL: string(input), Default: selected}
				if tag == "exit" {
					spec.Via = "entry"
				}
				data, err := json.Marshal(spec)
				if err != nil {
					t.Fatal(err)
				}
				if err := os.WriteFile(filepath.Join(dir, tag+".json"), data, 0o600); err != nil {
					t.Fatal(err)
				}
			}
			data, err := makeConfigFromDir(dir)
			if test.wantErr != "" {
				if err == nil || !strings.Contains(err.Error(), test.wantErr) {
					t.Fatalf("got %v, want %s", err, test.wantErr)
				}
				if data != nil {
					t.Fatal("returned config on error")
				}
				return
			}
			if err != nil {
				t.Fatal(err)
			}
			var config struct {
				Outbounds []struct {
					Tag    string `json:"tag"`
					Stream struct {
						Sockopt struct {
							Via string `json:"dialerProxy"`
						} `json:"sockopt"`
					} `json:"streamSettings"`
				} `json:"outbounds"`
				Routing struct {
					Rules []struct {
						Tag string `json:"outboundTag"`
					} `json:"rules"`
				} `json:"routing"`
			}
			if err := json.Unmarshal(data, &config); err != nil {
				t.Fatal(err)
			}
			if config.Outbounds[0].Tag != test.want {
				t.Fatal("default not first")
			}
			if config.Outbounds[0].Stream.Sockopt.Via != "entry" {
				t.Fatal("default lost its chain")
			}
			for i, rule := range config.Routing.Rules {
				want := "direct"
				if i == len(config.Routing.Rules)-1 {
					want = test.want
				}
				if rule.Tag != want {
					t.Fatalf("rule %d routes to %s, want %s", i, rule.Tag, want)
				}
			}
		})
	}
}
