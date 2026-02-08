local mod = "go_gopls_lsp_formatting"

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup(mod, {}),
	pattern = "*.go",
	callback = function(args)
		vim.lsp.buf.format({
			timeout_ms = 1000,
			bufnr = args.buf,
			filter = function(client) return client.name == "gopls" end,
		})
	end,
})
