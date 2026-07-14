local mod = "internal.lsp_kotlin_lsp"

local cmd = {
	-- brew install JetBrains/utils/kotlin-lsp
	vim.fn.expand("/opt/homebrew/bin/kotlin-lsp"),
	unpack(vim.lsp.config["kotlin_lsp"].cmd, 2),
}

local on_attach
do
	local internal_on_attach = vim.lsp.config["kotlin_lsp"].on_attach or function() end
	on_attach = function(client, bufnr)
		internal_on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("kotlin_lsp", {
	cmd = cmd,
	on_attach = on_attach,
})

vim.lsp.enable("kotlin_lsp")
