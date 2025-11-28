local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.visits" })

	require("mini.visits").setup({})
end

return M
