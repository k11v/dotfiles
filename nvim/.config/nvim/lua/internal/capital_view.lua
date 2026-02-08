local mod = "capital_view"

local function view_impl(expr)
  local v = _G
  for k in expr:gmatch("[^%.]+") do v = type(v) == "table" and v[k] or nil end
  if type(v) ~= "function" then return vim.notify("Not a function", vim.log.levels.ERROR) end

  local i = debug.getinfo(v, "S")
  if not i or i.what ~= "Lua" then return vim.notify("Not a Lua function", vim.log.levels.ERROR) end

  local src = (i.source or ""):gsub("^@", "")
  if src == "" then return vim.notify("No source", vim.log.levels.ERROR) end

  vim.cmd("view " .. vim.fn.fnameescape(src))
  vim.api.nvim_win_set_cursor(0, { i.linedefined > 0 and i.linedefined or 1, 0 })
end

pcall(vim.api.nvim_del_user_command, "View")
vim.api.nvim_create_user_command("View", function(o)
  view_impl(o.args)
end, { nargs = 1, complete = "lua" })
