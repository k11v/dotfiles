local opts = {
	max_lines = 1,
}

local config = function(_, opts)
	require("treesitter-context").setup(opts)
end

local plugin = {
	url = "https://github.com/nvim-treesitter/nvim-treesitter-context",
	event = { "LazyFile" },
	opts = opts,
	config = config,
}

return { plugin }
