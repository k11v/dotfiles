package main

type Transport interface {
	transport()
}

type TCPTransport struct{}

func (TCPTransport) transport() {}

type WebSocketTransport struct {
	Host string
	Path string
}

func (WebSocketTransport) transport() {}

type Security interface {
	security()
}

type TLSSecurity struct {
	ServerName  string
	Fingerprint string
}

type RealitySecurity struct {
	ServerName  string
	Fingerprint string
	PublicKey   string
	ShortID     string
}

func (TLSSecurity) security()     {}
func (RealitySecurity) security() {}

type VlessConnection struct {
	Host      string
	Port      int
	UserID    string
	Flow      string
	Transport Transport
	Security  Security
}
