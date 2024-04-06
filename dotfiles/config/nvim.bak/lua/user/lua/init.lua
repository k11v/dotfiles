local M = {}

local callback = function()
	vim.opt_local.colorcolumn = { "120" }
	vim.opt_local.expandtab = false
	vim.opt_local.shiftwidth = 4
	vim.opt_local.softtabstop = 4
	vim.opt_local.tabstop = 4
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("user_lua_init", {}),
		pattern = { "lua" },
		callback = callback,
	})
end

M.get_plugins = function(module)
	return { { import = module .. ".plugins" } }
end

return M
