return {
	{
		name = "nvim",
		dir = vim.fn.stdpath("config"),
		opts = {
			x_inits = {
				{
					lua = function()
						vim.opt_local.colorcolumn = "100"
						vim.opt_local.expandtab = false
						vim.opt_local.shiftwidth = 4
						vim.opt_local.softtabstop = 4
						vim.opt_local.tabstop = 4
					end,
				},
			},
		},
	},
	{
		"nvim-treesitter",
		opts = {
			x_parsers = {
				"lua",
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
							if vim.uv.fs_stat(w.name .. "/.luarc.json") then
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
										"${3rd}/luv/library", -- provides types for vim.uv
									},
								},
							})
					end,
				},
				efm = {
					x_formatting = true,
					x_tools = {
						{ lua = require("efmls-configs.formatters.stylua") },
					},
				},
			},
		},
	},
}
