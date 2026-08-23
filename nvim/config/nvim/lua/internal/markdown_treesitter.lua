local mod = "internal.markdown_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "markdown",
	callback = function(args)
		vim.b[args.buf].opt_treesitter = "markdown"
	end,
})
