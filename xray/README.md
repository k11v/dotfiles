# Xray

Install the module from the dotfiles repository root:

```sh
dot/bin/dot xray
```

Keep VLESS or Shadowsocks credentials in a separate, private module:

```text
~/private-dotfiles/vpn/xray/
├── entry.json
└── exit.json
```

Each JSON filename defines an outbound tag. The `url` accepts standard VLESS,
legacy base64 VLESS (WebSocket/TLS), or Shadowsocks links. For example, `entry.json`:

```json
{
  "url": "vless://UUID@entry.example.com:443?security=tls"
}
```

And `exit.json`:

```json
{
  "url": "vless://UUID@exit.example.com:443?security=tls",
  "via": "entry",
  "default": true
}
```

This sends proxied traffic through `computer → entry → exit → destination`.
Omit `via` for a single proxy. Exactly one outbound must set `default` to `true`;
`direct` is a reserved tag. Missing chain references and cycles are rejected.

Link the private module and generate the config:

```sh
dot/bin/dot ~/private-dotfiles/vpn
make-xray-config
```

The generator creates one proxy outbound per `~/.local/share/xray/integration/*.json`
file, adds the `direct` outbound, and writes
`~/.config/xray/config.json` with mode `0600`. Use `--input DIR` or `--output PATH`
to override these paths. If an older installation symlinked `~/.config/xray` into
the repository, remove that symlink before generating.

Install the LaunchAgent as a regular copy from the repository root. If `dot`
created a symlink, remove it before copying:

```sh
agent="$HOME/Library/LaunchAgents/cc.k11v.internal.xray.plist"
if [ -L "$agent" ]; then
    sudo unlink "$agent"
fi
sudo cp xray/launchagents/cc.k11v.internal.xray.plist "$agent"
```

Repeat the copy after changing the repository plist.

The LaunchAgent creates `~/.local/state/xray` and appends stdout and stderr to
`stdout.log` and `stderr.log` there using shell redirection.

Validate and restart an already loaded service:

```sh
/opt/homebrew/bin/xray run -test -c ~/.config/xray/config.json
launchctl kickstart -k gui/$(id -u)/cc.k11v.internal.xray
```
