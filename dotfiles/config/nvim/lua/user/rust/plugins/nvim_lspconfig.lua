local opts = {
	x_servers = {
		rust_analyzer = {
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					group = vim.api.nvim_create_augroup("user_rust_plugins_nvim_lspconfig", {}),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr, name = "rust_analyzer" })
					end,
				})
			end
		},
	},
}

local plugin = {
	"nvim-lspconfig",
	opts = opts,
}

return { plugin }
