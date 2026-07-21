local mod = "lcd"
local group = vim.api.nvim_create_augroup(mod, {})

-- apply ensures a window's local cwd always matches vim.b.localdir of its
-- buffer; without localdir the window falls back to the default window cwd.
local function apply(win)
	vim.api.nvim_win_call(win, function()
		local dir = vim.b.localdir or vim.fn.getcwd(-1, 0)
		if vim.fn.isdirectory(dir) == 1 and (vim.fn.haslocaldir(0) == 0 or vim.fn.getcwd(0) ~= dir) then
			vim.cmd.lcd(vim.fn.fnameescape(dir))
		end
	end)
end

-- When changing buffers, re-apply.
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	callback = function()
		apply(vim.api.nvim_get_current_win())
	end,
})

-- When leaving a buffer, reset to the default window cwd so that code running
-- before BufEnter (e.g. BufReadCmd) sees the incoming buffer's effective dir.
vim.api.nvim_create_autocmd("BufLeave", {
	group = group,
	callback = function()
		local dir = vim.fn.getcwd(-1, 0)
		if vim.fn.isdirectory(dir) == 1 and vim.fn.haslocaldir(0) == 1 and vim.fn.getcwd(0) ~= dir then
			vim.cmd.lcd(vim.fn.fnameescape(dir))
		end
	end,
})

-- When changing directories with ":cd" or ":tcd", re-apply
-- because ":lcd" has been reset as a side effect.
vim.api.nvim_create_autocmd("DirChanged", {
	group = group,
	pattern = { "global", "tabpage" },
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			apply(win)
		end
	end,
})

-- ":Lcd {path}" sets localdir ("%"-style cmdline specials are expanded),
-- ":Lcd" clears it.
pcall(vim.api.nvim_del_user_command, "Lcd")
vim.api.nvim_create_user_command("Lcd", function(o)
	local dir
	if o.args ~= "" then
		dir = vim.fs.abspath(vim.fs.normalize(vim.fn.expandcmd(o.args)))
		if vim.fn.isdirectory(dir) == 0 then
			vim.notify("Lcd: not a directory: " .. dir, vim.log.levels.ERROR)
			return
		end
	end
	vim.b.localdir = dir
	local buf = vim.api.nvim_get_current_buf()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			apply(win)
		end
	end
end, { nargs = "?", complete = "dir", desc = "Set buffer working directory" })
