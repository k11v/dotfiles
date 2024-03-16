require("user.plugins.utils").create_lazy_file_event()

require("lazy").setup({
	{
		url = "https://github.com/folke/tokyonight.nvim",
		lazy = false,
		priority = math.huge,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		event = { "LazyFile" }, -- TODO: Consider `{ "BufReadPost", "BufNewFile" }` instead
		build = function()
			vim.cmd.TSUpdate()
		end,
		opts = function()
			return require("user.plugins.configs.nvim-treesitter")
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
})
