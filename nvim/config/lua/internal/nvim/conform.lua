local is_filetype_formatter_enabled = {}

return {
	conform_filetypes_formatters = function(filetypes, formatters)
		for _, filetype in ipairs(filetypes) do
			is_filetype_formatter_enabled[filetype] = is_filetype_formatter_enabled[filetype] or {}
			for _, formatter in ipairs(formatters) do
				is_filetype_formatter_enabled[filetype][formatter] = true
			end
		end
	end,
	setup_conform = function()
		require("mini.deps").add({ source = "https://github.com/stevearc/conform.nvim" })

		require("conform").setup()

		for filetype, is_formatter_enabled in pairs(is_filetype_formatter_enabled) do
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetype,
				callback = function(args)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function(args)
							local is_enabled = false
							local formatters = {}

							for formatter, _ in pairs(is_formatter_enabled) do
								is_enabled = true
								table.insert(formatters, formatter)
							end

							if is_enabled then
								require("conform").format({
									bufnr = args.buf,
									formatters = formatters,
									timeout_ms = 1 * 1000,
								})
							end
						end,
					})
				end,
			})
		end
	end,
}
