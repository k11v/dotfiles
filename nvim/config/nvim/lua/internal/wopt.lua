local mod = "internal.wopt"
local group = vim.api.nvim_create_augroup(mod, {})

-- TODO: Ability to set window options once (e.g. to set wo.foldlevel once and replace go.foldlevelstart).

local function apply(win, buf)
	local wopts = {
		"foldexpr",
		"foldmethod", -- should be set after "foldexpr"
	}

	for _, wopt in ipairs(wopts) do
		local value = vim.b[buf]["wopt_" .. wopt]
		if value ~= nil and vim.wo[win][0][wopt] ~= value then
			vim.wo[win][0][wopt] = value
		end
	end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
	group = group,
	callback = function(args)
		local win = vim.api.nvim_get_current_win()
		if vim.api.nvim_win_get_buf(win) == args.buf then
			apply(win, args.buf)
		end
	end,
})
