local mod = "internal.lsp_sourcekit"

local cmd = {
	-- Install Xcode from App Store.
	vim.trim(vim.fn.system("xcode-select -p")) .. "/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
	unpack(vim.lsp.config["sourcekit"].cmd, 2),
}

local on_attach
do
	local internal_on_attach = vim.lsp.config["sourcekit"].on_attach or function() end
	on_attach = function(client, bufnr)
		internal_on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("sourcekit", {
	cmd = cmd,
	on_attach = on_attach,
})

vim.lsp.enable("sourcekit")
