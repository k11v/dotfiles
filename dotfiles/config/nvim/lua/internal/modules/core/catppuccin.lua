return {
	name = "catppuccin",
	url = "https://github.com/catppuccin/nvim",
	lazy = false,
	priority = math.huge,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
