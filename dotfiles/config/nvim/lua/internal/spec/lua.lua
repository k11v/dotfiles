return {
	{
		"nvim-lspconfig",
		opts = {
			x_servers = {
				lua_ls = {
					settings = {
						Lua = {},
					},
					on_init = function(client)
						-- If .luarc.json exists, configure Lua LS using it.
						for _, w in ipairs(client.workspace_folders) do
							if vim.loop.fs_stat(w.name .. "/.luarc.json") then
								return
							end
						end

						-- Otherwise configure Lua LS for the _currently running_ Neovim.
						client.config.settings.Lua =
							vim.tbl_deep_extend("force", client.config.settings.Lua, {
								runtime = {
									version = "LuaJIT",
								},
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
									},
								},
							})
					end,
				},
				efm = {
					x_tools = {
						{ "lua", require("efmls-configs.formatters.stylua") },
					},
				},
			},
		},
	},
	{
		"mason.nvim",
		opts = {
			x_packages = {
				"lua-language-server",
				"stylua",
			},
		},
	},
}
