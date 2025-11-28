local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini-git" })

	require("mini.git").setup()
end

return M
