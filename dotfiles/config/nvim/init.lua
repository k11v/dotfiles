local util = require("internal.util")

-- Install lazy.

local lazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazyPath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazyPath,
	})
end
vim.opt.rtp:prepend(lazyPath)

-- Register events.

util.RegisterLazyFile()

-- Load plugins.

require("lazy").setup({
	spec = {
		{
			name = "nvim",
			dir = vim.fn.stdpath("config"),
			lazy = false,
			opts = {
				inits_by_ft = {},
			},
			config = function(_, opts)
				local non_ft_inits = opts.inits_by_ft["*"] or {}
				opts.inits_by_ft["*"] = nil

				for _, i in ipairs(non_ft_inits) do
					i()
				end

				for ft, ft_inits in pairs(opts.inits_by_ft) do
					vim.api.nvim_create_autocmd({ "FileType" }, {
						group = vim.api.nvim_create_augroup("internal_nvim_inits_by_ft_" .. ft, {}),
						pattern = { ft },
						callback = function()
							for _, i in ipairs(ft_inits) do
								i()
							end
						end,
					})
				end
			end,
		},
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
				"editorconfig",
				"gzip",
				"health",
				"man",
				"matchit",
				"matchparen",
				"netrwPlugin",
				-- "nvim",
				"rplugin",
				-- "shada",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
