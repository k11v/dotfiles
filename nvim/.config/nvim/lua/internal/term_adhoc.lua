local mod = "term_adhoc"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = group,
	pattern = "x://term-adhoc",
	callback = function(args)
		vim.fn.termopen(vim.o.shell)
		vim.api.nvim_buf_set_name(args.buf, "x://term-adhoc")
	end,
})
