local M = {}

M.setup = function(opts)
	require("mini.deps").add({
		source = "https://github.com/nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})

	require("nvim-treesitter")
end

return M
