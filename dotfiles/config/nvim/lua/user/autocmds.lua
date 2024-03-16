local gitcommit_group = vim.api.nvim_create_augroup("UserFileTypeGitcommit", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = gitcommit_group,
	pattern = { "gitcommit" },
	callback = function()
		vim.opt_local.colorcolumn = { "50", "72" }
	end,
})

local lua_group = vim.api.nvim_create_augroup("UserFileTypeLua", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = rust_group,
	pattern = { "lua" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.tabstop = 4
	end,
})

local python_group = vim.api.nvim_create_augroup("UserFileTypePython", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = python_group,
	pattern = { "python" },
	callback = function()
		vim.opt_local.colorcolumn = { "88" }
	end,
})

local rust_group = vim.api.nvim_create_augroup("UserFileTypeRust", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = rust_group,
	pattern = { "rust" },
	callback = function()
		vim.opt_local.colorcolumn = { "100" }
	end,
})
