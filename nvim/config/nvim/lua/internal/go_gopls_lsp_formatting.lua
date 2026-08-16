local mod = "internal.go_gopls_lsp_formatting"

local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "*.go",
	callback = function(args)
		vim.lsp.buf.format({
			timeout_ms = 1000,
			bufnr = args.buf,
			filter = function(client)
				return client.name == "gopls"
			end,
		})
	end,
})
