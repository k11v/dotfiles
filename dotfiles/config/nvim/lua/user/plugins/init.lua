require("user.plugins.utils").create_lazy_file_event()

require("lazy").setup({
	spec = {
		{ import = "user.plugins.base" },
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
})
