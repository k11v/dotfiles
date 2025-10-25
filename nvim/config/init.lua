require("internal.nvim").setup({
	vim_setup_arms = {
		{
			pattern = {},
			value = function(bufnr)
				vim.opt_local.breakindent = true
				vim.opt_local.clipboard = ""
				vim.opt_local.confirm = true
				vim.opt_local.cursorline = true
				vim.opt_local.cursorlineopt = "number"
				vim.opt_local.foldlevelstart = 99
				vim.opt_local.foldtext = ""
				vim.opt_local.ignorecase = true
				vim.opt_local.inccommand = "split"
				vim.opt_local.list = true
				vim.opt_local.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
				vim.opt_local.mouse = "a"
				vim.opt_local.number = true
				vim.opt_local.report = 0
				vim.opt_local.scrolloff = 10
				vim.opt_local.shortmess = vim.tbl_deep_extend("force", {}, vim.opt_local.shortmess:get(), { I = true })
				vim.opt_local.showmode = false
				vim.opt_local.signcolumn = "yes"
				vim.opt_local.smartcase = true
				vim.opt_local.splitbelow = true
				vim.opt_local.splitright = true
				vim.opt_local.timeout = false
				vim.opt_local.undofile = true
				vim.opt_local.updatetime = 250
			end,
		},
		{
			pattern = {},
			value = function(bufnr)
				vim.opt_local.colorcolumn = { "80" }
				vim.opt_local.expandtab = false
				vim.opt_local.shiftwidth = 4
				vim.opt_local.softtabstop = 4
				vim.opt_local.tabstop = 4
			end,
		},
		{
			pattern = { ft = { "go" } },
			value = function(bufnr)
				vim.opt_local.colorcolumn = { "120" }
				vim.opt_local.expandtab = false
				vim.opt_local.shiftwidth = 4
				vim.opt_local.softtabstop = 4
				vim.opt_local.tabstop = 4
			end,
		},
	},
	vim_cd_arms = {
		{ pattern = {}, key = "main", value = true },
	},
	treesitter_parser_arms = {
		{ pattern = { ft = { "go" } }, key = "main", value = "go" },
	},
	treesitter_parser_folding_arms = {},
	treesitter_parser_indenting_arms = {},
	lsp_server_arms = {},
	lsp_server_formatting_arms = {},
	conform_formatter_formatting_arms = {},
	lint_linter_checking_arms = {},
})
