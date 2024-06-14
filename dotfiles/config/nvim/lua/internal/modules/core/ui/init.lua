return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					"*",
					function()
						vim.diagnostic.config({ float = { border = "single" } })
						vim.lsp.handlers["textDocument/hover"] = (
							vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
						)
						vim.lsp.handlers["textDocument/signatureHelp"] = (
							vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
						)
					end,
				},
			},
		},
	},
	{
	    "nvim-lspconfig",
	    opts = {
            x_inits = {
                function()
                    require('lspconfig.ui.windows').default_options = { border = "single" }
                end,
            },
	    },
	},
}
