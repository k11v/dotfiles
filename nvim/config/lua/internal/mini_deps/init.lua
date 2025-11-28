local M = {}

M.setup = function(opts)
	-- Uses git executable.

	do
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
	end
end

return M
