local util = require("internal.util")

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

util.register_lazyfile()

-- Load plugins.

require("lazy").setup({
	spec = {
		{
			name = "nvim",
			dir = vim.fn.stdpath("config"),
			lazy = false,
			opts = {
				x_inits = {}, -- User-defined
			},
			config = function(_, opts)
				local non_ft_init = opts.x_inits["*"] or function() end
				opts.x_inits["*"] = nil

				non_ft_init()

				for ft, ft_init in pairs(opts.x_inits) do
					vim.api.nvim_create_autocmd({ "FileType" }, {
						group = vim.api.nvim_create_augroup("internal_nvim_x_inits_" .. ft, {}),
						pattern = { ft },
						callback = function()
							ft_init()
						end,
					})
				end
			end,
		},
		{ import = "internal.spec" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	checker = {
		enabled = true,
		frequency = 86400, -- Every day
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
