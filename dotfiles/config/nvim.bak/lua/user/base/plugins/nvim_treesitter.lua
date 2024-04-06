local build = function()
	vim.cmd.TSUpdate()
end

local opts = {
	ensure_installed = { "c", "lua", "query", "vim", "vimdoc" },
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
}

local config = function(_, opts)
	require("nvim-treesitter.configs").setup(opts)
end

local plugin = {
	url = "https://github.com/nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-treesitter-textobjects" },
	build = build,
	opts = opts,
	config = config,
}

return { plugin }
