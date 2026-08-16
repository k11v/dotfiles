local mod = "internal.ft_agent"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = group,
	pattern = { "xx://agent", "xx://agent/*" },
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		vim.fn.jobstart("claude --allow-dangerously-skip-permissions", { term = true })
		vim.api.nvim_buf_set_name(args.buf, name)
	end,
})
