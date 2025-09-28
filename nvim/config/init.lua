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

-- Setup modules, order matters.

require("internal.nvim-go").setup()
require("internal.nvim-markdown").setup()

require("internal.nvim").setup()
