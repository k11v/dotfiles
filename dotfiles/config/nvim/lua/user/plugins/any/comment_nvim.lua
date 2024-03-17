local config = function()
	require("Comment").setup()
end

local plugin = {
	url = "https://github.com/numToStr/Comment.nvim",
	event = { "VeryLazy" },
	config = config,
}

return { plugin }
