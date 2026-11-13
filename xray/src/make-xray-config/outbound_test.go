package main

import (
	"encoding/base64"
	"testing"
)

func TestLegacyVlessOutbound(t *testing.T) {
	authority := base64.RawStdEncoding.EncodeToString([]byte("auto:00000000-0000-4000-8000-000000000000@entry.example.com:443"))
	outbound, err := parseOutbound("vless://"+authority+"?obfs=websocket&tls=1&peer=tls.example.com&obfsParam=ws.example.com&path=/api", "entry")
	if err != nil {
		t.Fatal(err)
	}
	stream := outbound["streamSettings"].(map[string]any)
	if stream["network"] != "websocket" || stream["security"] != "tls" {
		t.Fatal("missing WebSocket TLS")
	}
	ws := stream["wsSettings"].(map[string]any)
	if ws["host"] != "ws.example.com" || ws["path"] != "/api" {
		t.Fatal("incorrect WebSocket settings")
	}
	if stream["tlsSettings"].(map[string]any)["serverName"] != "tls.example.com" {
		t.Fatal("incorrect TLS name")
	}
}

func TestShadowsocksOutbound(t *testing.T) {
	credentials := "chacha20-ietf-poly1305:fake-password"
	for _, payload := range []string{
		base64.RawStdEncoding.EncodeToString([]byte(credentials + "@exit.example.com:61200")),
		base64.RawURLEncoding.EncodeToString([]byte(credentials)) + "@exit.example.com:61200",
	} {
		outbound, err := parseOutbound("ss://"+payload+"#Example", "exit")
		if err != nil {
			t.Fatal(err)
		}
		server := outbound["settings"].(map[string]any)["servers"].([]any)[0].(map[string]any)
		if outbound["protocol"] != "shadowsocks" || server["address"] != "exit.example.com" || server["port"] != 61200 || server["password"] != "fake-password" {
			t.Fatal("incorrect Shadowsocks outbound")
		}
	}
	for _, source := range []string{"ss://bad", "ss://none:secret@example.com:443", "ss://aes-128-gcm:secret@example.com:0"} {
		if _, err := parseOutbound(source, "exit"); err == nil {
			t.Fatal("accepted invalid Shadowsocks URL")
		}
	}
}
