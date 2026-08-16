# xray

Xray-core is a proxy platform. Run locally it exposes SOCKS and HTTP proxy
listeners on loopback and forwards traffic through a configured remote outbound.

It is not managed by `brew services`. It runs as a user LaunchAgent from a
hand-written plist.

## Management

Install:

```
cp cc.k11v.i.xray.plist ~/Library/LaunchAgents/cc.k11v.i.xray.plist
```

Start (plist should configure `RunAtLoad`):

```
plutil -replace Disabled -bool false ~/Library/LaunchAgents/cc.k11v.i.xray.plist
launchctl load ~/Library/LaunchAgents/cc.k11v.i.xray.plist
```

Restart:

```
launchctl stop cc.k11v.i.xray && sleep 1 && launchctl start cc.k11v.i.xray
```

Stop:

```
plutil -replace Disabled -bool true ~/Library/LaunchAgents/cc.k11v.i.xray.plist
launchctl unload ~/Library/LaunchAgents/cc.k11v.i.xray.plist
```

Show status (PID, last exit status, label):

```
launchctl list | rg xray
```

Show logs (plist should configure `StandardOutPath` and `StandardErrorPath`):

```
tail -f ~/.local/xray/stdout.log
tail -f ~/.local/xray/stderr.log
```

Show config (plist should configure `EnvironmentVariables` or
`ProgramArguments`):

```
cat ~/.local/xray/config.json
```
