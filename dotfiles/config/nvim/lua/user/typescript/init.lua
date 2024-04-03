local M = {}

local callback = function()
	vim.opt_local.colorcolumn = { "80" }
	vim.opt_local.shiftwidth = 2
	vim.opt_local.softtabstop = 2
	vim.opt_local.tabstop = 2
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("user_typescript_init", {}),
		pattern = { "typescript" },
		callback = callback,
	})
end

M.get_plugins = function(module)
	return {} -- TODO: Try returning `{ { import = module .. ".plugins" } }`
end

return M
