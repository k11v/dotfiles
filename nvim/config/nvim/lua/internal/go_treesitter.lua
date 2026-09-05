local mod = "internal.go_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "go",
	callback = function(args)
		-- nvim-treesitter-parser-install go https://github.com/tree-sitter/tree-sitter-go.git v0.25.0
		vim.b[args.buf].fopt_treesitter = "go"
		-- nvim-treesitter-query-install go https://github.com/tree-sitter/tree-sitter-go.git v0.25.0 queries/highlights.scm
		vim.b[args.buf].opt_treesitter_syntax = true
		vim.b[args.buf].wopt_foldmethod = "expr"
		-- nvim-treesitter-query-install go https://github.com/nvim-treesitter/nvim-treesitter.git main runtime/queries/go/folds.scm
		vim.b[args.buf].wopt_foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
