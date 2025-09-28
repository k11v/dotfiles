return {
	setup = function()
		require("internal.nvim").filetypes_setup({ "go", "gomod", "gowork", "gosum", "gotmpl" }, function()
			vim.opt.colorcolumn = { "120" }
			vim.opt.expandtab = false
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.tabstop = 4
		end)
		require("internal.nvim").treesitter_parsers({ "go", "gomod", "gowork", "gosum", "gotmpl" })
		require("internal.nvim").treesitter_highlighting_filetypes({ "go", "gomod", "gowork", "gosum", "gotmpl" })
		require("internal.nvim").treesitter_folding_filetypes({ "go", "gomod", "gowork", "gosum", "gotmpl" })
		require("internal.nvim").treesitter_indenting_filetypes({ "go", "gomod", "gowork", "gosum", "gotmpl" })
		require("internal.nvim").lsp_servers({ "gopls" })
		require("internal.nvim").executables({ "gopls" })
		require("internal.nvim").lsp_formatting_filetypes_servers({ "go" }, { "gopls" })
	end,
}
