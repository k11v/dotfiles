local config = function()
	require("mini.statusline").setup()
end

local plugin = {
	url = "https://github.com/echasnovski/mini.statusline",
	dependencies = { "nvim-web-devicons" }, -- Also depends on `gitsigns.nvim`
	lazy = false,
	config = config,
}

return { plugin }
