local utils = require("internal.utils")

-- Install lazy.

local lazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazyPath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazyPath,
	})
end
vim.opt.rtp:prepend(lazyPath)

-- Map leaders.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Register events.

utils.register_lazyfile()

-- Load plugins.

require("lazy").setup({
	spec = { import = "internal.modules" },
	defaults = {
		lazy = true,
		version = false,
	},
	checker = {
		enabled = true,
		frequency = 14 * 86400, -- Every 14 days
	},
	change_detection = {
		enabled = false, -- TODO: enable when notifications are less intrusive
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"bugreport",
				"compiler",
				"ftplugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"matchit",
				"netrw",
				"netrwFileHandlers",
				"netrwPlugin",
				"netrwSettings",
				"optwin",
				"rplugin",
				"rrhelper",
				"spellfile_plugin",
				"synmenu",
				"syntax",
				"tar",
				"tarPlugin",
				"tohtml",
				"tutor",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
			},
		},
	},
})
