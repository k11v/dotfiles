return {
	setup = function()
		require("internal.nvim").setup_filetypes({ "markdown" }, function()
			vim.opt.colorcolumn = { "80" }
			vim.opt.expandtab = false
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.tabstop = 4
		end)
		require("internal.nvim").treesitter_parsers({ "markdown", "markdown_inline" })
		require("internal.nvim").treesitter_highlighting_filetypes({ "markdown" })
	end,
}
