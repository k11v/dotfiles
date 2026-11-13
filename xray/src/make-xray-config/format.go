package main

func formatConfig(connection VlessConnection, tag string) map[string]any {
	stream := map[string]any{}
	switch transport := connection.Transport.(type) {
	case TCPTransport:
		stream["network"] = "tcp"
	case WebSocketTransport:
		stream["network"] = "websocket"
		settings := map[string]any{
			"path": transport.Path,
		}
		if transport.Host != "" {
			settings["host"] = transport.Host
		}
		stream["wsSettings"] = settings
	}
	switch security := connection.Security.(type) {
	case TLSSecurity:
		stream["security"] = "tls"
		stream["tlsSettings"] = map[string]any{
			"serverName":  security.ServerName,
			"fingerprint": security.Fingerprint,
		}
	case RealitySecurity:
		stream["security"] = "reality"
		stream["realitySettings"] = map[string]any{
			"serverName":  security.ServerName,
			"fingerprint": security.Fingerprint,
			"publicKey":   security.PublicKey,
			"shortId":     security.ShortID,
		}
	}
	sniffing := map[string]any{
		"enabled": true,
		"destOverride": []string{
			"http",
			"tls",
			"quic",
		},
		"routeOnly": true,
	}
	return map[string]any{
		"log": map[string]any{
			"loglevel": "warning",
		},
		"routing": map[string]any{
			"domainStrategy": "IPOnDemand",
			"rules": []any{
				map[string]any{
					"type": "field",
					"protocol": []string{
						"bittorrent",
					},
					"outboundTag": "direct",
				},
				map[string]any{
					"type": "field",
					"domain": []string{
						"geosite:private",
						"geosite:category-ru",
					},
					"outboundTag": "direct",
				},
				map[string]any{
					"type": "field",
					"ip": []string{
						"geoip:private",
						"geoip:ru",
					},
					"outboundTag": "direct",
				},
				map[string]any{
					"type":        "field",
					"network":     "tcp,udp",
					"outboundTag": tag,
				},
			},
		},
		"inbounds": []any{
			map[string]any{
				"listen":   "127.0.0.1",
				"port":     1080,
				"protocol": "socks",
				"settings": map[string]any{
					"udp":       true,
					"userLevel": 0,
				},
				"sniffing": sniffing,
			},
			map[string]any{
				"listen":   "127.0.0.1",
				"port":     1081,
				"protocol": "http",
				"settings": map[string]any{
					"userLevel": 0,
				},
				"sniffing": sniffing,
			},
		},
		"outbounds": []any{
			map[string]any{
				"tag":            tag,
				"protocol":       "vless",
				"streamSettings": stream,
				"settings": map[string]any{
					"vnext": []any{
						map[string]any{
							"address": connection.Host,
							"port":    connection.Port,
							"users": []any{
								map[string]any{
									"id":         connection.UserID,
									"encryption": "none",
									"flow":       connection.Flow,
								},
							},
						},
					},
				},
			},
			map[string]any{
				"tag":      "direct",
				"protocol": "freedom",
				"settings": map[string]any{},
			},
		},
	}
}
