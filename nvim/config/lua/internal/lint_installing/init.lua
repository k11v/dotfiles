local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/mfussenegger/nvim-lint" })

	require("lint")
end

return M
