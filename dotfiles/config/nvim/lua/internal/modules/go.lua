return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					["*"] = function()
						-- gotmpl filetype LIKELY isn't used by the built-in runtime
						-- but it is used by nvim-lspconfig's gopls.
						vim.filetype.add({ extension = { ["tmpl"] = "gotmpl" } })
					end,
					go = function()
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
				"gotmpl",
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
							-- Enable template file support for *.tmpl files.
							-- gopls must be enabled for these files separately.
							templateExtensions = { "tmpl" },
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
					---@param client vim.lsp.Client
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
						client.server_capabilities.documentOnTypeFormattingProvider = nil

						-- A workaround for gopls not supporting semanticTokensProvider.
						-- See https://github.com/golang/go/issues/54531#issuecomment-1464982242.
						local semanticTokens =
							client.config.capabilities.textDocument.semanticTokens
						if
							not client.server_capabilities.semanticTokensProvider
							and semanticTokens ~= nil
						then
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semanticTokens.tokenTypes,
									tokenModifiers = semanticTokens.tokenModifiers,
								},
								range = true,
							}
						end
					end,
				},
				efm = {
					x_formatting = true,
					x_tools = {
						{ go = require("efmls-configs.formatters.gofumpt") },
						{ go = require("efmls-configs.formatters.goimports") },
					},
				},
			},
		},
	},
}
