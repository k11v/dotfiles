local init = function()
	vim.o.statusline = " " -- Show empty statusline until loaded
end

local config = function()
	require("mini.statusline").setup()
end

local plugin = {
	url = "https://github.com/echasnovski/mini.statusline",
	dependencies = { "nvim-web-devicons", "gitsigns.nvim" }, -- TODO: Consider removing `gitsigns.nvim`
	event = { "VeryLazy" },
	init = init,
	config = config,
}

return { plugin }
