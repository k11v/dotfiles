package main

import (
	"encoding/base64"
	"errors"
	"net"
	"net/url"
	"strconv"
	"strings"
)

func decodeLink(value string) (string, error) {
	for _, encoding := range []*base64.Encoding{base64.RawURLEncoding, base64.URLEncoding, base64.RawStdEncoding, base64.StdEncoding} {
		if decoded, err := encoding.DecodeString(value); err == nil {
			return string(decoded), nil
		}
	}
	return "", errors.New("invalid base64 proxy credentials")
}

func parseOutbound(source, tag string) (map[string]any, error) {
	if strings.HasPrefix(source, "ss://") {
		return parseShadowsocks(source, tag)
	}
	// Legacy clients encode auto:UUID@host:port as the VLESS authority.
	if strings.HasPrefix(source, "vless://") {
		authority, query, _ := strings.Cut(strings.TrimPrefix(source, "vless://"), "?")
		if !strings.Contains(authority, "@") {
			decoded, err := decodeLink(authority)
			if err != nil {
				return nil, err
			}
			decoded = strings.TrimPrefix(decoded, "auto:")
			params, err := url.ParseQuery(query)
			if err != nil {
				return nil, errors.New("invalid URL query")
			}
			if params.Get("obfs") == "websocket" {
				params.Set("type", "ws")
			}
			if params.Get("tls") == "1" {
				params.Set("security", "tls")
			}
			if params.Has("obfsParam") {
				params.Set("host", params.Get("obfsParam"))
			}
			if params.Has("peer") {
				params.Set("sni", params.Get("peer"))
			}
			source = "vless://" + decoded + "?" + params.Encode()
		}
	}
	connection, err := parseURL(source)
	if err != nil {
		return nil, err
	}
	return formatConfig(connection, tag)["outbounds"].([]any)[0].(map[string]any), nil
}

func parseShadowsocks(source, tag string) (map[string]any, error) {
	payload, _, _ := strings.Cut(strings.TrimPrefix(source, "ss://"), "#")
	if !strings.Contains(payload, "@") {
		decoded, err := decodeLink(payload)
		if err != nil {
			return nil, err
		}
		payload = decoded
	} else {
		credentials, address, _ := strings.Cut(payload, "@")
		if !strings.Contains(credentials, ":") {
			decoded, err := decodeLink(credentials)
			if err != nil {
				return nil, err
			}
			payload = decoded + "@" + address
		}
	}
	credentials, address, found := strings.Cut(payload, "@")
	method, password, valid := strings.Cut(credentials, ":")
	if !found || !valid || password == "" {
		return nil, errors.New("invalid Shadowsocks credentials")
	}
	if method != "chacha20-ietf-poly1305" && method != "aes-128-gcm" && method != "aes-256-gcm" {
		return nil, errors.New("unsupported Shadowsocks method")
	}
	host, portText, err := net.SplitHostPort(address)
	port, portErr := strconv.Atoi(portText)
	if err != nil || portErr != nil || host == "" || port < 1 || port > 65535 {
		return nil, errors.New("invalid Shadowsocks host or port")
	}
	return map[string]any{
		"tag": tag, "protocol": "shadowsocks",
		"streamSettings": map[string]any{},
		"settings":       map[string]any{"servers": []any{map[string]any{"address": host, "port": port, "method": method, "password": password}}},
	}, nil
}
