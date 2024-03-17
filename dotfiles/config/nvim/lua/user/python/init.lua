local M = {}

local callback = function()
	vim.opt_local.colorcolumn = { "88" }
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("user_python_init", {}),
		pattern = { "python" },
		callback = callback,
	})
end

M.get_plugins = function(module)
	return { { import = module .. ".plugins" } }
end

return M
