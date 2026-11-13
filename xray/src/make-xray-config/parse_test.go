package main

import (
	"reflect"
	"strings"
	"testing"
)

func Test_parseURL(t *testing.T) {
	const base = "vless://00000000-0000-4000-8000-000000000000@[::1]:443?"
	tls := TLSSecurity{
		ServerName:  "::1",
		Fingerprint: "chrome",
	}
	reality := RealitySecurity{
		ServerName:  "::1",
		Fingerprint: "chrome",
		PublicKey:   strings.Repeat("A", 43),
		ShortID:     "abcd",
	}
	for _, test := range []struct {
		name      string
		source    string
		transport Transport
		security  Security
		flow      string
		wantErr   bool
	}{
		{
			name:      "TLS",
			source:    base + "security=tls",
			transport: TCPTransport{},
			security:  tls,
		},
		{
			name:   "WebSocket",
			source: base + "security=tls&type=ws&host=example.com&path=%2Fproxy",
			transport: WebSocketTransport{
				Host: "example.com",
				Path: "/proxy",
			},
			security: tls,
		},
		{
			name:      "REALITY",
			source:    base + "security=reality&pbk=" + strings.Repeat("A", 43) + "&sid=abcd&flow=xtls-rprx-vision",
			transport: TCPTransport{},
			security:  reality,
			flow:      "xtls-rprx-vision",
		},
		{
			name:      "legacy REALITY",
			source:    base + "security=reality#pbk=" + strings.Repeat("A", 43) + "&sid=abcd",
			transport: TCPTransport{},
			security:  reality,
		},
		{
			name:    "wrong scheme",
			source:  "https://example.com",
			wantErr: true,
		},
		{
			name:    "invalid UUID",
			source:  "vless://bad@example.com:443?security=tls",
			wantErr: true,
		},
		{
			name:    "missing user",
			source:  "vless://example.com:443?security=tls",
			wantErr: true,
		},
		{
			name:    "password",
			source:  "vless://user:password@example.com:443",
			wantErr: true,
		},
		{
			name:    "invalid port",
			source:  "vless://00000000-0000-4000-8000-000000000000@example.com:0?security=tls",
			wantErr: true,
		},
		{
			name:    "unsupported security",
			source:  base + "security=none",
			wantErr: true,
		},
		{
			name:    "missing public key",
			source:  base + "security=reality",
			wantErr: true,
		},
		{
			name:    "unsupported transport",
			source:  base + "security=tls&type=bad",
			wantErr: true,
		},
		{
			name:    "Vision with WebSocket",
			source:  base + "security=tls&type=ws&flow=xtls-rprx-vision",
			wantErr: true,
		},
		{
			name:    "duplicate parameter",
			source:  base + "security=tls&security=tls",
			wantErr: true,
		},
		{
			name:    "unsupported encryption",
			source:  base + "security=tls&encryption=bad",
			wantErr: true,
		},
		{
			name:    "invalid short ID",
			source:  base + "security=reality&pbk=" + strings.Repeat("A", 43) + "&sid=abc",
			wantErr: true,
		},
		{
			name:    "invalid escaping",
			source:  base + "security=tls&path=%zz",
			wantErr: true,
		},
	} {
		t.Run(test.name, func(t *testing.T) {
			got, err := parseURL(test.source)
			if (err != nil) != test.wantErr {
				t.Fatalf("parseURL() error = %v, wantErr %v", err, test.wantErr)
			}
			if test.wantErr {
				return
			}
			want := VlessConnection{
				Host:      "::1",
				Port:      443,
				UserID:    "00000000-0000-4000-8000-000000000000",
				Flow:      test.flow,
				Transport: test.transport,
				Security:  test.security,
			}
			if !reflect.DeepEqual(got, want) {
				t.Fatalf("parseURL() = %#v, want %#v", got, want)
			}
		})
	}
}
