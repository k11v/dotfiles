return {
	setup = function()
		require("internal.nvim").setup_filetypes({ "go", "gomod", "gowork", "gosum" }, function()
			vim.opt.colorcolumn = { "120" }
			vim.opt.expandtab = false
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.tabstop = 4
		end)
		require("internal.nvim").treesitter_parsers({ "go", "gomod", "gowork", "gosum" })
		require("internal.nvim").treesitter_highlighting_filetypes({ "go", "gomod", "gowork", "gosum" })
		require("internal.nvim").treesitter_folding_filetypes({ "go", "gomod", "gowork", "gosum" })
		require("internal.nvim").treesitter_indenting_filetypes({ "go", "gomod", "gowork", "gosum" })
		require("internal.nvim").lsp_servers({ "gopls" })
		require("internal.nvim").executables({ "gopls" })
	end,
}
