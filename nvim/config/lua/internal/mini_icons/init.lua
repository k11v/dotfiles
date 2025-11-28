local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.icons" })

	require("mini.icons").setup({})
end

return M
