local config = function()
	vim.cmd.colorscheme("tokyonight-night")
end

local plugin = {
	url = "https://github.com/folke/tokyonight.nvim",
	lazy = false,
	priority = math.huge,
	config = config,
}

return { plugin }
