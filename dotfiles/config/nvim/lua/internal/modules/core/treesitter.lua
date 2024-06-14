local utils = require("internal.utils")

return {
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "v1.x.x",
		dependencies = { "nvim-treesitter-textobjects" },
		event = "LazyFile",
		opts_extend = { "x_parsers" },
		opts = {
			x_parsers = { "c", "lua", "query", "vim", "vimdoc" },
			auto_install = true,
			highlight = { enable = true },
			incremental_selection = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
					include_surrounding_whitespace = true,
				},
			},
		},
		build = function()
			vim.cmd.TSUpdate()
		end,
		config = function(_, opts)
			opts.ensure_installed = utils.without_duplicates(opts.x_parsers)
			opts.x_parsers = nil

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {},
		event = nil,
	},
}
