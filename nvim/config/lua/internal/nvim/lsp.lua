local lsp_servers = {}

return {
	lsp_servers = function(servers)
		for _, server in ipairs(servers) do
			table.insert(lsp_servers, server)
		end
	end,
	setup_lsp = function()
		require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

		vim.lsp.enable(lsp_servers)
	end,
}
