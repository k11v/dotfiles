local mod = "internal.term_osc7"
local group = vim.api.nvim_create_augroup(mod, {})

-- Shells announce their cwd via OSC 7 (see the zsh osc7 integration);
-- treat it as ":bcd" for the terminal buffer. The path is ignored when it
-- doesn't exist locally (e.g. an ssh session announcing a remote cwd).
vim.api.nvim_create_autocmd("TermRequest", {
	group = group,
	callback = function(args)
		local path = args.data.sequence:match("^\027]7;file://[^/]*(/.*)$")
		if not path then
			return
		end
		path = path:gsub("%%(%x%x)", function(hex)
			return string.char(tonumber(hex, 16))
		end)
		if vim.fn.isdirectory(path) == 0 then
			return
		end
		vim.api.nvim_buf_call(args.buf, function()
			vim.cmd.bcd(vim.fn.fnameescape(path))
		end)
	end,
})
