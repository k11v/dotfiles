local mod = "internal.treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

-- TODO: Handle treesitter fold (need buffer-window-opt).
-- TODO: Handle treesitter config.
-- TODO: Handle errors in do treesitter.

--- @class internal.treesitter.Opt
--- @field treesitter? string
--- @field treesitter_fold? boolean
--- @field treesitter_config? { [string]: table }

local function handle(buf)
	local treesitter = vimx.coalesce({
		vim.b[buf].opt_treesitter,
		vim.g.opt_treesitter,
		"",
	})

	vim.validate("opt_treesitter", treesitter, "string")

	if vim.b[buf].var_treesitter_undo ~= nil then
		vim.b[buf].var_treesitter_undo()
		vim.b[buf].var_treesitter_undo = nil
	end

	if treesitter ~= "" then
		pcall(vim.treesitter.start, buf, treesitter)
		vim.b[buf].var_treesitter_undo = function()
			pcall(vim.treesitter.stop, buf)
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		handle(args.buf)
	end,
})
