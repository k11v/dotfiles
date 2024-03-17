local M = {}

local callback = function()
	vim.opt_local.colorcolumn = { "50", "72" }
end

M.setup = function()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = vim.api.nvim_create_augroup("user_git_init", {}),
		pattern = { "gitcommit" },
		callback = callback,
	})
end

M.get_plugins = function(module)
	return {} -- TODO: Try returning `{ { import = module .. ".plugins" } }`
end

return M
