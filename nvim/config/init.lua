require("internal.nvim").setup({
	vim_opt_arms = {
		{ pattern = { ft = { "go" } }, key = "colorcolumn", value = { "120" } },
		{ pattern = { ft = { "go" } }, key = "expandtab", value = false },
		{ pattern = { ft = { "go" } }, key = "shiftwidth", value = 4 },
		{ pattern = { ft = { "go" } }, key = "softtabstop", value = 4 },
		{ pattern = { ft = { "go" } }, key = "tabstop", value = 4 },
		{ pattern = {}, key = "breakindent", value = true },
		{ pattern = {}, key = "clipboard", value = "" },
		{ pattern = {}, key = "confirm", value = true },
		{ pattern = {}, key = "cursorline", value = true },
		{ pattern = {}, key = "cursorlineopt", value = "number" },
		{ pattern = {}, key = "foldlevelstart", value = 99 }, -- FIXME: probably not respected in BufEnter
		{ pattern = {}, key = "foldtext", value = "" },
		{ pattern = {}, key = "ignorecase", value = true },
		{ pattern = {}, key = "inccommand", value = "split" },
		{ pattern = {}, key = "list", value = true },
		{ pattern = {}, key = "listchars", value = { tab = "» ", trail = "·", nbsp = "␣" } },
		{ pattern = {}, key = "mouse", value = "a" },
		{ pattern = {}, key = "number", value = true },
		{ pattern = {}, key = "report", value = 0 },
		{ pattern = {}, key = "scrolloff", value = 10 },
		-- stylua: ignore start
		{ pattern = {}, key = "shortmess", value = vim.tbl_deep_extend("force", {}, vim.opt_local.shortmess:get(), { I = true }) },
		-- stylua: ignore end
		{ pattern = {}, key = "showmode", value = false },
		{ pattern = {}, key = "signcolumn", value = "yes" },
		{ pattern = {}, key = "smartcase", value = true },
		{ pattern = {}, key = "splitbelow", value = true },
		{ pattern = {}, key = "splitright", value = true },
		{ pattern = {}, key = "timeout", value = false },
		{ pattern = {}, key = "undofile", value = true },
		{ pattern = {}, key = "updatetime", value = 250 },
		{ pattern = {}, key = "colorcolumn", value = { "80" } },
		{ pattern = {}, key = "expandtab", value = false },
		{ pattern = {}, key = "shiftwidth", value = 4 },
		{ pattern = {}, key = "softtabstop", value = 4 },
		{ pattern = {}, key = "tabstop", value = 4 },
	},
	vim_directory_changing_arms = {
		{ pattern = {}, value = true },
	},
	mise_tool_arms = {
		{ pattern = { ft = { "go" } }, key = "core:go", value = "1.24" }, -- temporary for demo purposes
		{ pattern = { ft = { "go" } }, key = "aqua:golangci/golangci-lint", value = "1" }, -- temporary for demo purposes
		{ pattern = {}, key = "core:go", value = "latest" },
		{ pattern = {}, key = "aqua:golangci/golangci-lint", value = "2" },
		{ pattern = {}, key = "go:golang.org/x/tools/gopls", value = "latest" },
		{ pattern = {}, key = "aqua:LuaLS/lua-language-server", value = "latest" },
		{ pattern = {}, key = "aqua:JohnnyMorganz/StyLua", value = "latest" },
	},
	treesitter_arms = {
		{ pattern = { ft = { "go" } }, value = true },
		{ pattern = { ft = { "gomod" } }, value = true },
		{ pattern = { ft = { "gosum" } }, value = true },
		{ pattern = { ft = { "gotmpl" } }, value = true },
		{ pattern = { ft = { "gowork" } }, value = true },
		{ pattern = { ft = { "markdown" } }, value = { "markdown", "markdown_inline" } },
	},
	treesitter_folding_arms = {
		{ pattern = { ft = { "go" } }, value = true },
	},
	treesitter_indenting_arms = {
		{ pattern = { ft = { "go" } }, value = true },
	},
	lsp_server_arms = {
		{ pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
		{ pattern = { ft = { "lua" } }, key = "lua_ls", value = true },
	},
	lsp_server_formatting_arms = {
		{ pattern = { ft = { "go", "gomod", "gowork", "gotmpl" } }, key = "gopls", value = true },
	},
	conform_formatter_formatting_arms = {
		{ pattern = { ft = { "lua" } }, key = "stylua", value = true },
	},
	lint_linter_checking_arms = {
		{ pattern = { ft = { "go" }, root = { "go.mod" } }, key = "golangcilint", value = true },
	},
})
