local mod = "internal.go_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "go",
	callback = function(args)
		vim.b[args.buf].fopt_treesitter = "go"
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gomod",
	callback = function(args)
		vim.b[args.buf].fopt_treesitter = "gomod"
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gosum",
	callback = function(args)
		vim.b[args.buf].fopt_treesitter = "gosum"
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gotmpl",
	callback = function(args)
		vim.b[args.buf].fopt_treesitter = "gotmpl"
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gowork",
	callback = function(args)
		vim.b[args.buf].fopt_treesitter = "gowork"
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
