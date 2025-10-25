-- Setup mini.deps.

local deps_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.deps"

if not vim.loop.fs_stat(deps_path) then
	vim.cmd('echo "Installing `mini.deps`" | redraw')
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.deps",
		deps_path,
	})
	vim.cmd("packadd mini.deps | helptags ALL")
	vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require("mini.deps").setup()

-- Setup nvim.

require("internal.nvim").setup({
	vim_setup_arms = {},
	vim_cd_arms = {
		{ pattern = {}, value = true },
	},
	treesitter_parser_arms = {},
	treesitter_parser_folding_arms = {},
	treesitter_parser_indenting_arms = {},
	lsp_server_arms = {},
	lsp_server_formatting_arms = {},
	conform_formatter_formatting_arms = {},
	lint_linter_checking_arms = {},
})
