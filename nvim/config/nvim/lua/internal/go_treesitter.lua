local mod = "internal.go_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "go",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "go"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gomod",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "gomod"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gosum",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "gosum"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gotmpl",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "gotmpl"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gowork",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "gowork"
	end,
})
