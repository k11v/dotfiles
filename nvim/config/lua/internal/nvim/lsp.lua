local lsp_servers = {}

local is_filetype_server_formatting_enabled = {}

return {
	lsp_servers = function(servers)
		for _, server in ipairs(servers) do
			table.insert(lsp_servers, server)
		end
	end,
	lsp_formatting_filetypes_servers = function(filetypes, servers)
		for _, filetype in ipairs(filetypes) do
			is_filetype_server_formatting_enabled[filetype] = is_filetype_server_formatting_enabled[filetype] or {}
			for _, server in ipairs(servers) do
				is_filetype_server_formatting_enabled[filetype][server] = true
			end
		end
	end,
	setup_lsp = function()
		require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

		vim.lsp.enable(lsp_servers)

		for filetype, is_server_formatting_enabled in pairs(is_filetype_server_formatting_enabled) do
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetype,
				callback = function(args)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function(args)
							local is_enabled = false
							local servers = {}

							local clients = vim.lsp.get_clients({ bufnr = args.buf })
							for _, client in ipairs(clients) do
								if is_server_formatting_enabled[client.name] then
									is_enabled = true
									servers[client.name] = true
								end
							end

							if is_enabled then
								vim.lsp.buf.format({
									bufnr = args.buf,
									filter = function(client)
										return not not servers[client.name]
									end,
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
