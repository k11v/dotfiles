---@param message
---@return nil
local function notify_and_error(message)
  local notification = hs.notify:new()
  notification:title("Hammerspoon")
  notification:informativeText(message)
  notification:send()
  error(message)
end

---@return hs.application|nil
local function get_alacritty()
  local alacritties = hs.application.applicationsForBundleID("org.alacritty")
  return #alacritties < 1 and nil or alacritties[1]
end

---@param alacritty hs.application
---@return boolean
local function is_alacritty_active_app(alacritty)
  return alacritty:isFrontmost()
end

---@return integer
local function get_active_space()
  return hs.spaces.focusedSpace()
end

---@param space integer
---@return hs.screen
local function get_space_screen(space)
  local space_screen = hs.screen.find(hs.spaces.spaceDisplay(space))
  if not space_screen then
    notify_and_error("Expected a space screen, got nil.")
  end
  return space_screen
end

---@param window hs.window
---@param space integer
---@return boolean
local function is_window_on_space(window, space)
  for _, s in ipairs(hs.spaces.windowSpaces(window)) do
    if s == space then
      return true
    end
  end
  return false
end

---@param alacritty hs.application
---@return hs.window
local function get_alacritty_window(alacritty)
  local alacritty_window = alacritty:mainWindow()
  if not alacritty_window then
    notify_and_error("Expected an Alacritty window, got nil.")
  end
  if not alacritty_window:isStandard() then
    notify_and_error("Expected a standard alacritty window, got non-standard.")
  end
  if alacritty_window:isFullScreen() then
    notify_and_error("Expected a non-full-screen alacritty window, got full-screen.")
  end
  return alacritty_window
end

---@param alacritty hs.application
---@return nil
local function hide_alacritty(alacritty)
  alacritty:hide()
end

---@param alacritty hs.application
---@param relative_height? number
---@return nil
local function show_alacritty(alacritty, relative_height)
  local alacritty_window = get_alacritty_window(alacritty)
  local active_space = get_active_space()

  local window_frame = alacritty_window:frame()
  local window_screen_frame = alacritty_window:screen():frame()
  local active_screen_frame = get_space_screen(active_space):frame()

  local is_window_full_screen = window_frame.h >= window_screen_frame.h

  local absolute_height
  if relative_height == nil then
    absolute_height = (
      is_window_full_screen
      and active_screen_frame.h
      or math.min(window_frame.h, active_screen_frame.h)
    )
  else
    absolute_height = (
      active_screen_frame.h * math.min(math.max(0, relative_height), 1)
    )
  end

  if not is_window_on_space(alacritty_window, active_space) then
    alacritty:hide()
    hs.spaces.moveWindowToSpace(alacritty_window, active_space)
  end
  alacritty_window:setFrame(hs.geometry({
    x = active_screen_frame.x,
    y = active_screen_frame.y,
    w = active_screen_frame.w,
    h = absolute_height,
  }), 0)
  alacritty:activate()
  alacritty:unhide()
end

---@param alacritty hs.application
---@return nil
local function toggle_alacritty(alacritty)
  if is_alacritty_active_app(alacritty) then
    hide_alacritty(alacritty)
  else
    show_alacritty(alacritty)
  end
end

---@return hs.application
local function open_alacritty()
  local alacritty = hs.application.open("org.alacritty", 1, true)
  if not alacritty then
    notify_and_error("Expected an Alacritty instance, got nil.")
  end
  return alacritty
end

hs.hotkey.bind({"alt"}, "`", function()
  local alacritty = get_alacritty()
  if alacritty then
    toggle_alacritty(alacritty)
  else
    show_alacritty(open_alacritty(), 1)
  end
end)

hs.hotkey.bind({"shift", "alt"}, "`", function()
  local alacritty = get_alacritty()
  if alacritty then
    show_alacritty(alacritty, 1)
  else
    show_alacritty(open_alacritty(), 1)
  end
end)
