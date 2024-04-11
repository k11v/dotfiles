local config = function()
	require("mini.surround").setup()
end

local plugin = {
	url = "https://github.com/echasnovski/mini.surround",
	event = { "VeryLazy" },
	config = config,
}

return { plugin }
