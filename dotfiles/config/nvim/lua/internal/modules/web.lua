return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					css = function()
						vim.opt_local.colorcolumn = "120"
						vim.opt_local.expandtab = true
						vim.opt_local.shiftwidth = 2
						vim.opt_local.softtabstop = 2
						vim.opt_local.tabstop = 2
					end,
					html = function()
						vim.opt_local.colorcolumn = "120"
						vim.opt_local.expandtab = true
						vim.opt_local.shiftwidth = 2
						vim.opt_local.softtabstop = 2
						vim.opt_local.tabstop = 2
					end,
					javascript = function()
						vim.opt_local.colorcolumn = "120"
						vim.opt_local.expandtab = true
						vim.opt_local.shiftwidth = 2
						vim.opt_local.softtabstop = 2
						vim.opt_local.tabstop = 2
					end,
				},
			},
		},
	},
	{
		"nvim-treesitter",
		opts = {
			x_parsers = {
				"css",
				"html",
				"javascript",
			},
		},
	},
	{
		"mason.nvim",
		opts = {
			x_packages = {
				"prettier",
			},
		},
	},
	{
		"nvim-lspconfig",
		opts = {
			x_servers = {
				efm = {
					x_formatting = true,
					x_tools = {
						{ css = require("efmls-configs.formatters.prettier") },
						{ html = require("efmls-configs.formatters.prettier") },
						{ javascript = require("efmls-configs.formatters.prettier") },
					},
				},
			},
		},
	},
}
