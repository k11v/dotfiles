hs.hotkey.bind({"alt"}, "`", function()
  local alacritty = hs.application.find("alacritty")

  if alacritty and alacritty:isFrontmost() then
    alacritty:hide()
  else
    hs.application.launchOrFocus("alacritty")
  end
end)
