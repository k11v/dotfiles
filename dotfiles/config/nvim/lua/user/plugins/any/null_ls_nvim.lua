local opts = {
	sources = {},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("UserBaseNullLS", {}),
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
}

local config = function(_, opts)
	require("null-ls").setup(opts)
end

local plugin = {
	url = "https://github.com/nvimtools/none-ls.nvim",
	dependencies = { "plenary.nvim" },
	event = { "LazyFile" },
	opts = opts,
	config = config,
}

return { plugin }
