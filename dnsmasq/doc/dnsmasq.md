# dnsmasq

dnsmasq is a lightweight caching DNS forwarder. Run locally it listens on
loopback and forwards queries to upstream resolvers, so any client pointed at
`127.0.0.1` resolves through it regardless of the resolvers the network
supplies.

It is managed by `brew services`, which generates and loads a launchd job. The
formula requires root, so every command takes `sudo`.

## Management

Start:

```
sudo brew services start dnsmasq
```

Restart:

```
sudo brew services restart dnsmasq
```

Stop:

```
sudo brew services stop dnsmasq
```

Show status:

```
sudo brew services list
```

Show logs (no log file, goes to the unified log):

```
log stream --predicate 'process == "dnsmasq"'
log show --predicate 'process == "dnsmasq"' --last 1h
```

Show config (formula sets that):

```
cat /opt/homebrew/etc/dnsmasq.conf
```

## Other

### Flush DNS cache

macOS caches in front of dnsmasq, so a full flush clears both.

```
# dnsmasq cache
sudo killall -HUP dnsmasq

# macOS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### Test dnsmasq

```
dig +short @127.0.0.1 example.com
```
