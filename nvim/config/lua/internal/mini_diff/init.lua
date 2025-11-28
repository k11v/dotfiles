local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.diff" })

	require("mini.diff").setup({
		view = { style = "sign", priority = 100 },
	})
end

return M
