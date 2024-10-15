return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					"go",
					function()
						vim.opt_local.colorcolumn = "120"
						vim.opt_local.expandtab = false
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
				"go",
				"gomod",
				"gosum",
				"gowork",
			},
		},
	},
	{
		"mason.nvim",
		opts = {
			x_packages = {
				"delve",
				"gofumpt",
				"goimports",
				"gomodifytags",
				"impl",
			},
		},
	},
	{
		"nvim-lspconfig",
		opts = {
			x_servers = {
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = {
								"-.git",
								"-.vscode",
								"-.idea",
								"-.vscode-test",
								"-node_modules",
							},
							semanticTokens = true,
						},
					},
					on_attach = function(client, _)
						-- workaround for gopls not supporting semanticTokensProvider
						-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semantic.tokenTypes,
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
						-- end workaround
					end,
				},
				efm = {
					x_tools = {
						{ "go", require("efmls-configs.formatters.gofumpt") },
						{ "go", require("efmls-configs.formatters.goimports") },
					},
				},
			},
		},
	},
}
