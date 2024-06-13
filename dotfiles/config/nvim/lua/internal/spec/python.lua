return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					"python",
					function()
						vim.opt_local.colorcolumn = "88"
						vim.opt_local.expandtab = true
						vim.opt_local.shiftwidth = 4
						vim.opt_local.softtabstop = 4
						vim.opt_local.tabstop = 4
					end,
				},
			},
		},
	},
	{
		"nvim-treesitter",
		opts = {
			x_parsers = {
				"python",
			},
		},
	},
	{
		"mason.nvim",
		opts = {
			x_packages = {
				"basedpyright",
				"ruff",
			},
		},
	},
	{
		"nvim-lspconfig",
		opts = {
			x_servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "standard",
							},
						},
					},
				},
				ruff = {
					on_attach = function(client, bufnr)
						client.server_capabilities.hoverProvider = false

						vim.api.nvim_create_autocmd({ "BufWritePre" }, {
							group = vim.api.nvim_create_augroup(
								"internal_lspconfig_ruff_bufwritepre",
								{}
							),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.code_action({
									apply = true,
									filter = function(a)
										return a.kind == "source.fixAll.ruff"
									end,
								})
							end,
						})
					end,
				},
			},
		},
	},
}
