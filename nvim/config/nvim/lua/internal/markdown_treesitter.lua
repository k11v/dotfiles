local mod = "internal.markdown_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "markdown",
	callback = function(args)
		-- built-in
		vim.b[args.buf].fopt_treesitter = "markdown"
		-- built-in
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		-- built-in
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
