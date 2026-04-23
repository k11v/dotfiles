local mod = "term_agent"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = group,
	pattern = "x://term-agent",
	callback = function(args)
		vim.fn.termopen("claude --model claude-opus-4-7 --allow-dangerously-skip-permissions")
		vim.api.nvim_buf_set_name(args.buf, "x://term-agent")
	end,
})
