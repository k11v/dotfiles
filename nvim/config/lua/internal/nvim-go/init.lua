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

		require("internal.nvim").executables({ "gopls" })
		require("internal.nvim").lsp_servers({ "gopls" })
		require("internal.nvim").lsp_formatting_filetypes_servers({ "go" }, { "gopls" })

		require("internal.nvim").executables({ "go", "golangci-lint" })
		require("internal.nvim").lint_filetypes_linters_condition({ "go" }, { "golangcilint" }, function()
			-- See https://github.com/mfussenegger/nvim-lint/blob/335a6044be16d7701001059cba9baa36fbeef422/lua/lint/linters/golangcilint.lua#L77.
			local package = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")

			-- When Go file is outside main Go module, linter doesn't run.
			local command = vim.system({ "go", "list", package })
			local result = command:wait(1 * 1000)
			return result.code == 0
		end)
	end,
}
