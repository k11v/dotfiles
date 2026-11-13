package main

import (
	"bytes"
	"embed"
	"strings"
	"testing"
)

//go:embed testdata/*/*
var fixtures embed.FS

func Test_makeConfig(t *testing.T) {
	for _, test := range []struct {
		name    string
		fixture string
		tag     string
		wantErr string
	}{
		{
			name:    "TLS",
			fixture: "tls",
			tag:     "proxy",
		},
		{
			name:    "WebSocket with custom tag",
			fixture: "websocket",
			tag:     "custom-proxy",
		},
		{
			name:    "REALITY",
			fixture: "reality",
			tag:     "proxy",
		},
		{
			name:    "invalid URL",
			fixture: "invalid",
			tag:     "proxy",
		},
		{
			name:    "empty proxy tag",
			fixture: "tls",
			wantErr: "proxy tag must be nonempty and different from direct",
		},
		{
			name:    "reserved proxy tag",
			fixture: "tls",
			tag:     "direct",
			wantErr: "proxy tag must be nonempty and different from direct",
		},
	} {
		t.Run(test.name, func(t *testing.T) {
			input, err := fixtures.ReadFile("testdata/" + test.fixture + "/input.url")
			if err != nil {
				t.Fatal(err)
			}

			wantErr := test.wantErr
			if test.fixture == "invalid" {
				data, err := fixtures.ReadFile("testdata/invalid/error.txt")
				if err != nil {
					t.Fatal(err)
				}
				wantErr = strings.TrimSpace(string(data))
			}

			got, err := makeConfig(string(input), test.tag)
			if wantErr != "" {
				if err == nil || err.Error() != wantErr {
					t.Fatalf("makeConfig() error = %v, want %q", err, wantErr)
				}
				if got != nil {
					t.Fatalf("makeConfig() returned config on error: %s", got)
				}
				return
			}
			if err != nil {
				t.Fatal(err)
			}

			want, err := fixtures.ReadFile("testdata/" + test.fixture + "/config.json")
			if err != nil {
				t.Fatal(err)
			}
			if !bytes.Equal(got, want) {
				t.Fatalf("config differs from fixture:\ngot:\n%s\nwant:\n%s", got, want)
			}
		})
	}
}
