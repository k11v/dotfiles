local mod = "ft_term"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = group,
	pattern = { "xx://term", "xx://term/*" },
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		vim.fn.jobstart(vim.o.shell, { term = true })
		vim.api.nvim_buf_set_name(args.buf, name)
	end,
})
