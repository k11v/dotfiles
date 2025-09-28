local filetype_linter_condition = {}

return {
	lint_filetypes_linters_condition = function(filetypes, linters, condition)
		for _, filetype in ipairs(filetypes) do
			filetype_linter_condition[filetype] = filetype_linter_condition[filetype] or {}
			for _, linter in ipairs(linters) do
				filetype_linter_condition[filetype][linter] = condition
			end
		end
	end,
	setup_lint = function()
		require("mini.deps").add({ source = "https://github.com/mfussenegger/nvim-lint" })

		require("lint") -- lint doesn't have setup function.

		for filetype, linter_condition in pairs(filetype_linter_condition) do
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetype,
				callback = function(args)
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = args.buf,
						callback = function(args)
							local is_enabled = false
							local linters = {}

							for linter, condition in pairs(linter_condition) do
								if condition(args) then
									is_enabled = true
									table.insert(linters, linter)
								end
							end

							if is_enabled then
								require("lint").try_lint(linters)
							end
						end,
					})
				end,
			})
		end
	end,
}
