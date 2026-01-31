local mod = "go_gopls_lsp_import_organizing"

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup(mod, {}),
	pattern = "*.go",
	callback = function(args)
		vim.lsp.buf.code_action({
			context = {
				-- diagnostics = {}, -- here we don't need any diagnostics
				only = { "source.organizeImports" },
				-- triggerKind = 2, -- automatic
			},
			filter = function(_, client_id) return vim.lsp.get_client_by_id(client_id).name == "gopls" end,
			apply = true,
			-- range = { ... }, -- default is to respect selection but probably action ignores it
			-- timeout_ms = 1000, -- didn't find in the docs
			-- bufnr = args.buf, -- didn't find in the docs
		})
	end,
})
