local mod = "internal.treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

-- TODO: Handle treesitter fold (need buffer-window-opt).
-- TODO: Handle treesitter config.

--- @class internal.treesitter.Opt
--- @field treesitter? string
--- @field treesitter_fold? boolean
--- @field treesitter_config? { [string]: table }

local function handle_treesitter(buf)
	if vim.b[buf].var_treesitter_undo ~= nil then
		vim.b[buf].var_treesitter_undo()
		vim.b[buf].var_treesitter_undo = nil
	end

	local treesitter = vimx.coalesce({
		vim.b[buf].opt_treesitter,
		vim.g.opt_treesitter,
		"",
	})

	vim.validate("treesitter", treesitter, "string")

	if treesitter ~= "" then
		(function()
			local ok, err = pcall(function()
				vim.treesitter.start(buf, treesitter)
			end)
			if not ok then
				vim.notify(string.format("%s: start treesitter: %s", mod, vim.inspect(err)), vim.log.levels.ERROR)
				return
			end
		end)()

		vim.b[buf].var_treesitter_undo = function()
			local ok, err = pcall(function()
				vim.treesitter.stop(buf)
			end)
			if not ok then
				vim.notify(string.format("%s: stop treesitter: %s", mod, vim.inspect(err)), vim.log.levels.ERROR)
				return
			end
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		handle_treesitter(args.buf)
	end,
})
