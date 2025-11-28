local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.notify" })

	require("mini.notify").setup({})
end

return M
