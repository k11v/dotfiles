local mod = "internal.lsp_gopls"

local cmd = {
	-- tool="go:golang.org/x/tools/gopls@latest"; mise install "$tool"; mise bin-paths "$tool"
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

-- Updated at: https://go.dev/gopls/release/v0.23.0.
vim.lsp.config("gopls", {
	cmd = cmd,
	on_attach = on_attach,
	settings = {
		gopls = {
			buildFlags = { "-tags=dev,integration" },
			directoryFilters = { "-.git" },
			gofumpt = true,
			renameMovesSubpackages = true,
			semanticTokens = true,
			staticcheck = true,
			usePlaceholders = true,
		},
	},
})

vim.lsp.enable("gopls")
