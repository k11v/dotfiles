local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(hyper, "q", function()
	hs.application.launchOrFocus("Alacritty")
end)

hs.hotkey.bind(hyper, "w", function()
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "e", function()
	hs.application.launchOrFocus("Telegram")
end)

hs.hotkey.bind(hyper, "r", function()
	hs.application.launchOrFocus("Mattermost")
end)

hs.hotkey.bind(hyper, "t", function()
	hs.application.launchOrFocus("Толк")
end)

hs.hotkey.bind(hyper, "y", function()
	hs.application.launchOrFocus("Spotify")
end)
