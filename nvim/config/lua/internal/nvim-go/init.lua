return {
	setup = function()
		require("internal.nvim").filetype_setup("go", function()
			vim.opt.colorcolumn = { "120" }
			vim.opt.expandtab = false
			vim.opt.shiftwidth = 4
			vim.opt.softtabstop = 4
			vim.opt.tabstop = 4
		end)
		require("internal.nvim").treesitter_parsers({ "go", "gomod", "gowork", "gosum" })
	end,
}
