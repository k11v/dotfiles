local mod = "internal.notify"

--- See https://github.com/neovim/neovim/blob/v0.12.4/runtime/lua/vim/_core/editor.lua#L548.
---@param msg string
---@param level integer|nil
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level)
	local chunks = {
		{ msg, level == vim.log.levels.ERROR and "ErrorMsg" or level == vim.log.levels.WARN and "WarningMsg" or nil },
	}
	vim.api.nvim_echo(chunks, true, {})
end
