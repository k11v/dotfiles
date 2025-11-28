local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/stevearc/conform.nvim" })

	require("conform")
end

return M
