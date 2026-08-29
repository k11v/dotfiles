local mod = "internal.treesitter_syntax"
local group = vim.api.nvim_create_augroup(mod, {})

local function handle_treesitter_syntax(buf)
	if vim.b[buf].var_treesitter_syntax_undo ~= nil then
		vim.b[buf].var_treesitter_syntax_undo()
		vim.b[buf].var_treesitter_syntax_undo = nil
	end

	local treesitter_syntax = vimx.coalesce({
		vim.b[buf].opt_treesitter_syntax,
		vim.g.opt_treesitter_syntax,
		false,
	})

	vim.validate("treesitter_syntax", treesitter_syntax, "boolean")

	if treesitter_syntax == true then
		(function()
			local ok, err = pcall(function()
				local filetype = vim.bo[buf].filetype
				local language = vim.treesitter.language.get_lang(filetype)
				vim.treesitter.start(buf, language)
			end)
			if not ok then
				vim.notify(string.format("%s: start treesitter: %s", mod, vim.inspect(err)), vim.log.levels.ERROR)
				return
			end
		end)()

		vim.b[buf].var_treesitter_syntax_undo = function()
			local ok, err = pcall(function()
				vim.treesitter.stop(buf)
			end)
			if not ok then
				vim.notify(string.format("%s: stop treesitter: %s", mod, vim.inspect(err)), vim.log.levels.ERROR)
				return
			end
		end
	else
		(function()
			local ok, err = pcall(function()
				vim.treesitter.stop(buf)
			end)
			if not ok then
				vim.notify(string.format("%s: stop treesitter: %s", mod, vim.inspect(err)), vim.log.levels.ERROR)
				return
			end
		end)()
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		handle_treesitter_syntax(args.buf)
	end,
})
