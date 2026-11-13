package main

import (
	"encoding/json"
	"reflect"
	"strings"
	"testing"
)

func Test_formatConfig(t *testing.T) {
	for _, test := range []struct {
		name         string
		tag          string
		network      string
		security     string
		transport    Transport
		settings     Security
		wantSettings map[string]any
	}{
		{
			"TLS",
			"proxy",
			"tcp",
			"tls",
			TCPTransport{},
			TLSSecurity{
				"example.com",
				"chrome",
			},
			map[string]any{
				"serverName":  "example.com",
				"fingerprint": "chrome",
			},
		},
		{
			"WebSocket",
			"custom-proxy",
			"websocket",
			"tls",
			WebSocketTransport{
				"example.com",
				"/proxy",
			},
			TLSSecurity{
				"example.com",
				"chrome",
			},
			map[string]any{
				"serverName":  "example.com",
				"fingerprint": "chrome",
			},
		},
		{
			"REALITY",
			"custom-proxy",
			"tcp",
			"reality",
			TCPTransport{},
			RealitySecurity{
				"example.com",
				"chrome",
				strings.Repeat("A", 43),
				"abcd",
			},
			map[string]any{
				"serverName":  "example.com",
				"fingerprint": "chrome",
				"publicKey":   strings.Repeat("A", 43),
				"shortId":     "abcd",
			},
		},
	} {
		t.Run(test.name, func(t *testing.T) {
			connection := VlessConnection{
				Host:      "example.com",
				Port:      443,
				UserID:    "00000000-0000-4000-8000-000000000000",
				Transport: test.transport,
				Security:  test.settings,
			}
			config := formatConfig(connection, test.tag)
			outbound := config["outbounds"].([]any)[0].(map[string]any)
			stream := outbound["streamSettings"].(map[string]any)
			if outbound["tag"] != test.tag || stream["network"] != test.network || stream["security"] != test.security {
				t.Fatalf("wrong outbound: %+v", outbound)
			}
			if !reflect.DeepEqual(stream[test.security+"Settings"], test.wantSettings) {
				t.Fatalf("wrong security settings: %+v", stream)
			}
			if test.network == "websocket" && !reflect.DeepEqual(stream["wsSettings"], map[string]any{
				"host": "example.com",
				"path": "/proxy",
			}) {
				t.Fatalf("wrong WebSocket settings: %+v", stream)
			}
			if _, err := json.Marshal(config); err != nil {
				t.Fatal(err)
			}
			tags := map[string]bool{}
			for _, outbound := range config["outbounds"].([]any) {
				tags[outbound.(map[string]any)["tag"].(string)] = true
			}
			routing := config["routing"].(map[string]any)
			if routing["domainStrategy"] != "IPOnDemand" {
				t.Fatal("Russian IP matching must resolve domains before the catch-all")
			}
			rules := routing["rules"].([]any)
			for i, entry := range rules {
				rule := entry.(map[string]any)
				tag := rule["outboundTag"].(string)
				if !tags[tag] {
					t.Fatalf("rule %d refers to missing outbound %q", i, tag)
				}
				if i < len(rules)-1 && tag != "direct" {
					t.Fatalf("direct exceptions must precede the proxy catch-all: %v", rule)
				}
			}
			first := rules[0].(map[string]any)
			if first["protocol"].([]string)[0] != "bittorrent" {
				t.Fatal("torrent routing must take priority over geographic routing")
			}
			last := rules[len(rules)-1].(map[string]any)
			if last["network"] != "tcp,udp" || last["outboundTag"] != test.tag {
				t.Fatal("catch-all must send both TCP and UDP to the chosen proxy tag")
			}
		})
	}
}
