local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.pick" })

	require("mini.pick").setup({})
end

return M
