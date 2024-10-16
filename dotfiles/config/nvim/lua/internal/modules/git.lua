return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					gitcommit = function()
						vim.opt_local.colorcolumn = { "50", "72" }
					end,
				},
			},
		},
	},
	{
		"nvim-treesitter",
		opts = {
			x_parsers = {
				"gitcommit",
			},
		},
	},
}
