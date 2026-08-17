local mod = "internal.treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

-- TODO: Handle undo treesitter.
-- TODO: Handle treesitter fold (need buffer-window-opt).
-- TODO: Handle treesitter config.
-- TODO: Handle errors in do treesitter.

--- @class internal.treesitter.Opt
--- @field treesitter? string
--- @field treesitter_fold? boolean
--- @field treesitter_config? { [string]: table }

local function coalesce(a)
	for i = 1, #a do
		local v = a[i]
		if v ~= nil then
			return v
		end
	end
	return nil
end

local function do_treesitter(buf, treesitter)
	if treesitter ~= "" then
		pcall(vim.treesitter.start, buf, treesitter)
		return function()
			pcall(vim.treesitter.stop, buf)
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		local treesitter = coalesce({
			vim.b[args.buf].opt.treesitter,
			vim.g.opt.treesitter,
			"",
		})
		vim.validate("treesitter", treesitter, "string")
		do_treesitter(args.buf, treesitter)
	end,
})
