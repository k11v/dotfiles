local M = {}

for _, m in ipairs({
	require("internal.nvim.conform"),
	require("internal.nvim.lint"),
	require("internal.nvim.lsp"),
	require("internal.nvim.treesitter"),
	require("internal.nvim.vim"),
}) do
	for k, v in pairs(m) do
		M[k] = v
	end
end

M.setup = function()
	M.setup_vim()
	M.setup_treesitter()
	M.setup_lsp()
	M.setup_conform()
	M.setup_lint()
end

return M
