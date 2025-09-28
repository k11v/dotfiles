return {
	setup = function()
		require("internal.nvim").filetypes_setup({ "lua" }, function()
			vim.opt.colorcolumn = { "120" }
			vim.opt.expandtab = false
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.tabstop = 4
		end)
		require("internal.nvim").treesitter_parsers({ "lua" })
		require("internal.nvim").treesitter_highlighting_filetypes({ "lua" })
		require("internal.nvim").treesitter_folding_filetypes({ "lua" })
		require("internal.nvim").treesitter_indenting_filetypes({ "lua" })

		require("internal.nvim").conform_filetypes_formatters({ "lua" }, { "stylua" })
		require("internal.nvim").executables({ "stylua" })
	end,
}
