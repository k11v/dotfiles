package main

import (
	"encoding/hex"
	"errors"
	"fmt"
	"net/url"
	"regexp"
	"strconv"
	"strings"
)

var uuidPattern = regexp.MustCompile(`^[0-9a-fA-F]{32}$`)
var publicKeyPattern = regexp.MustCompile(`^[A-Za-z0-9_-]{43}$`)

func parseURL(source string) (VlessConnection, error) {
	var connection VlessConnection
	u, err := url.Parse(source)
	if err != nil {
		// Do not echo a URL containing credentials in diagnostics.
		return connection, errors.New("invalid VLESS URL")
	}
	if u.Scheme != "vless" {
		return connection, errors.New("expected a vless:// URL")
	}
	port, err := strconv.Atoi(u.Port())
	if u.Hostname() == "" || err != nil || port < 1 || port > 65535 {
		return connection, errors.New("VLESS URL requires a host and port between 1 and 65535")
	}
	if u.User == nil {
		return connection, errors.New("VLESS URL requires a UUID as the username")
	}
	if _, present := u.User.Password(); present {
		return connection, errors.New("VLESS URL does not support a password")
	}
	id := strings.ToLower(u.User.Username())
	id = strings.TrimPrefix(id, "urn:uuid:")
	id = strings.Trim(id, "{}")
	id = strings.ReplaceAll(id, "-", "")
	if !uuidPattern.MatchString(id) {
		return connection, errors.New("VLESS user ID must be a UUID")
	}
	id = fmt.Sprintf("%s-%s-%s-%s-%s", id[:8], id[8:12], id[12:16], id[16:20], id[20:])
	params, err := url.ParseQuery(u.RawQuery)
	if err != nil {
		return connection, errors.New("invalid URL query")
	}
	for _, values := range params {
		if len(values) != 1 {
			return connection, errors.New("duplicate URL parameters are not supported")
		}
	}
	// Older links put REALITY parameters in the fragment.
	for part := range strings.SplitSeq(u.Fragment, "&") {
		key, value, found := strings.Cut(part, "=")
		if found && (key == "pbk" || key == "sid") && !params.Has(key) {
			params.Set(key, value)
		}
	}
	if params.Has("encryption") && params.Get("encryption") != "none" {
		return connection, errors.New("only VLESS encryption=none is supported")
	}
	connection = VlessConnection{
		Host:   u.Hostname(),
		Port:   port,
		UserID: id,
		Flow:   params.Get("flow"),
	}
	if connection.Flow != "" && connection.Flow != "xtls-rprx-vision" {
		return connection, errors.New("unsupported VLESS flow")
	}
	network := "tcp"
	if params.Has("type") {
		network = params.Get("type")
	}
	switch network {
	case "tcp":
		connection.Transport = TCPTransport{}
	case "ws":
		if connection.Flow != "" {
			return connection, errors.New("WebSocket transport does not support Vision flow")
		}
		path := "/"
		if params.Has("path") {
			path = params.Get("path")
		}
		connection.Transport = WebSocketTransport{
			Host: params.Get("host"),
			Path: path,
		}
	default:
		return connection, errors.New("unsupported transport")
	}
	serverName, fingerprint := params.Get("sni"), params.Get("fp")
	if serverName == "" {
		serverName = connection.Host
	}
	if fingerprint == "" {
		fingerprint = "chrome"
	}
	switch params.Get("security") {
	case "tls":
		connection.Security = TLSSecurity{
			ServerName:  serverName,
			Fingerprint: fingerprint,
		}
	case "reality":
		publicKey, shortID := params.Get("pbk"), params.Get("sid")
		if !publicKeyPattern.MatchString(publicKey) {
			return connection, errors.New("REALITY requires a 43-character base64url public key (pbk)")
		}
		if _, err := hex.DecodeString(shortID); err != nil || len(shortID) > 16 {
			return connection, errors.New("REALITY sid must be even-length hex, at most 16 characters")
		}
		connection.Security = RealitySecurity{
			ServerName:  serverName,
			Fingerprint: fingerprint,
			PublicKey:   publicKey,
			ShortID:     shortID,
		}
	default:
		return connection, errors.New("unsupported security")
	}
	return connection, nil
}
