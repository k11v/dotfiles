local opts = {
	signs = {
		add = { text = "▌" },
		change = { text = "▌" },
		delete = { text = "▖" },
		topdelete = { text = "▘" },
		changedelete = { text = "▌" },
		untracked = { text = "▌" },
	},
}

local config = function(_, opts)
	require("gitsigns").setup(opts)
end

local plugin = {
	url = "https://github.com/lewis6991/gitsigns.nvim",
	event = { "LazyFile" },
	opts = opts,
	config = config,
}

return { plugin }
