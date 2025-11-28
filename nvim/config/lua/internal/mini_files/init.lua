local M = {}

M.setup = function(opts)
	require("mini.deps").add({ source = "https://github.com/nvim-mini/mini.files" })

	require("mini.files").setup({
		mappings = { close = "<esc>" },
	})
end

return M
