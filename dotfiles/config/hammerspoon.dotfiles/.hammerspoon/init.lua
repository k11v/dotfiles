local function hide_alacritty(alacritty)
  alacritty:hide()
end

local function show_alacritty(alacritty)
  local alacritty_window = alacritty:mainWindow()

  if alacritty_window and alacritty_window:isStandard() then
    local focused_space_id = hs.spaces.focusedSpace()
    local focused_screen_id = hs.spaces.spaceDisplay(focused_space_id)

    window_frame = alacritty_window:frame()
    screen_frame = hs.screen.find(focused_screen_id):frame()

    alacritty_window:setFrame(
      hs.geometry({
        x = screen_frame.x,
        y = screen_frame.y,
        w = screen_frame.w,
        h = window_frame.h,
      }),
      0
    )

    hs.spaces.moveWindowToSpace(alacritty_window, focused_space_id)
  end

  alacritty:activate()
  alacritty:unhide()
  -- FIXME: The Alacritty window flickers when it is being shown from the
  -- "hidden" state. When it is visible, no flickering occurs.
end

local function toggle_alacritty(alacritty)
  if alacritty:isFrontmost() then
    hide_alacritty(alacritty)
  else
    show_alacritty(alacritty)
  end
end

hs.hotkey.bind({"alt"}, "`", function()
  local alacritty = hs.application.find("alacritty")

  if alacritty then
    toggle_alacritty(alacritty)
  else
    hs.application.launchOrFocus("alacritty")
    -- TODO: Make 'show_alacritty(alacritty)' work in the case when the app was
    -- just launched. 'hs.application.open' didn't seem to help.
  end
end)
