local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

	require("lspconfig")
end

return M
