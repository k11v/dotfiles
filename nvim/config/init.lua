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
				vim.opt_local.foldlevelstart = 99 -- FIXME: probably not respected in BufEnter
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
	mise_tool_arms = {
		{ pattern = {}, key = "core:go", value = "latest" },
		{ pattern = { ft = { "go" } }, key = "aqua:golangci/golangci-lint", value = "1" }, -- temporary for demo purposes
		{ pattern = {}, key = "aqua:golangci/golangci-lint", value = "2" },
		{ pattern = {}, key = "go:golang.org/x/tools/gopls", value = "latest" },
		{ pattern = {}, key = "aqua:LuaLS/lua-language-server", value = "latest" },
		{ pattern = {}, key = "aqua:JohnnyMorganz/StyLua", value = "latest" },
	},
	treesitter_arms = {
		{ pattern = { ft = { "go" } }, key = "main", value = true },
		{ pattern = { ft = { "gomod" } }, key = "main", value = true },
		{ pattern = { ft = { "gosum" } }, key = "main", value = true },
		{ pattern = { ft = { "gotmpl" } }, key = "main", value = true },
		{ pattern = { ft = { "gowork" } }, key = "main", value = true },
		{ pattern = { ft = { "markdown" } }, key = "main", value = { "markdown", "markdown_inline" } },
	},
	treesitter_folding_arms = {
		{ pattern = { ft = { "go" } }, key = "main", value = true },
	},
	treesitter_indenting_arms = {
		{ pattern = { ft = { "go" } }, key = "main", value = true },
	},
	lsp_server_arms = {
		{ pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
		{ pattern = { ft = { "lua" } }, key = "lua_ls", value = true },
	},
	lsp_server_formatting_arms = {
		{ pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
	},
	conform_formatter_formatting_arms = {},
	lint_linter_checking_arms = {},
})
