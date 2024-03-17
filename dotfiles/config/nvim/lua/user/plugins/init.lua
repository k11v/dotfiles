require("user.plugins.utils").create_lazy_file_event()

require("lazy").setup({
	spec = {
		{ import = "user.plugins.any" },
		-- { import = "user.plugins.javascript" },
		-- { import = "user.plugins.lua" },
		-- { import = "user.plugins.python" },
		-- { import = "user.plugins.rust" },
		-- { import = "user.plugins.tailwind" },
		-- { import = "user.plugins.vue" },
	},
	defaults = {
		lazy = true, -- TODO: Review
		version = false, -- TODO: Review
	},
	install = {
		colorscheme = { "tokyonight" },
	},
	checker = {
		enabled = true,
		-- frequency = 3600, -- TODO: Consider
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
