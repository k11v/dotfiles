return {
	url = "https://github.com/lewis6991/gitsigns.nvim",
	event = { "LazyFile", "VeryLazy" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "│" },
			topdelete = { text = "│" },
			changedelete = { text = "│" },
			untracked = { text = "│" },
		},
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)
	end,
}
