local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.extra" })

	require("mini.extra").setup({})
end

return M
