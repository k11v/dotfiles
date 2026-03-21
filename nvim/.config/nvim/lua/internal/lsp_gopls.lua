local mod = "internal.lsp_gopls"

local cmd = {
	vim.fn.expand("~/.local/share/mise/installs/go-golang-org-x-tools-gopls/latest/bin/gopls"),
	unpack(vim.lsp.config["gopls"].cmd, 2),
}

local on_attach
do
	local internal_on_attach = vim.lsp.config["gopls"].on_attach or function() end
	on_attach = function(client, bufnr)
		internal_on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("gopls", {
	cmd = cmd,
	on_attach = on_attach,
	settings = {
		gopls = {
			buildFlags = { "-tags=dev,integration" },
			directoryFilters = { "-.git" },
			gofumpt = true,
			renameMovesSubpackages = true, -- requires gopls >= 0.21.0
			semanticTokens = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	}
})

vim.lsp.enable("gopls")
