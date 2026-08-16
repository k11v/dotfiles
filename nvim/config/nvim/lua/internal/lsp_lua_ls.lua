local mod = "internal.lsp_lua_ls"

local cmd = {
	-- tool="aqua:LuaLS/lua-language-server@latest"; mise install "$tool"; mise bin-paths "$tool"
	vim.fn.expand("~/.local/share/mise/installs/aqua-lua-ls-lua-language-server/latest/bin/lua-language-server"),
	unpack(vim.lsp.config["lua_ls"].cmd, 2),
}

local on_attach
do
	local internal_on_attach = vim.lsp.config["lua_ls"].on_attach or function() end
	on_attach = function(client, bufnr)
		internal_on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("lua_ls", {
	cmd = cmd,
	on_attach = on_attach,
})

vim.lsp.enable("lua_ls")
