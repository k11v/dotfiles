local M = {}

local callback = function()
	vim.opt_local.colorcolumn = { "100" }
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("user_rust_init", {}),
		pattern = { "rust" },
		callback = callback,
	})
end

M.get_plugins = function(module)
	return { { import = module .. ".plugins" } }
end

return M
