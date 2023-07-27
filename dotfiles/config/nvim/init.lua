--
-- Globals
--

local globals = vim.g

globals.mapleader = " " -- Set global leader to space.
globals.maplocalleader = " " -- Set local leader to space.

--
-- Options
--

local options = vim.opt

options.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.

--
-- Plugins
--

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	print("Installing lazy.nvim")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	})
	print("Installed lazy.nvim")
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
	-- Package manager
	{
		"williamboman/mason.nvim",
		dependencies = nil,
		init = nil,
		config = function()
			local mason = require("mason")
			local mason_registry = require("mason-registry")

			local packages = {
				-- lspconfig
				"pyright",

				-- null-ls
				"black",
			}

			mason.setup()
			mason_registry.refresh(
				function() -- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732
					for _, pkg_name in ipairs(packages) do
						local pkg = mason_registry.get_package(pkg_name)
						if not pkg:is_installed() then
							pkg:install()
						end
					end
				end
			)
		end,
		build = function()
			vim.cmd.MasonUpdate()
		end,
		lazy = false, -- Lazy-loading mason.nvim is not recommended.
	},

	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		dependencies = nil,
		init = nil,
		config = function()
			require("luasnip").setup({
				history = true, -- Enables jumping back into exited snippet.
				update_events = { "TextChanged", "TextChangedI" }, -- Enables active snippet rerender on change.
				delete_check_events = { "TextChanged" }, -- Enables deleted snippet removal from history on change.
			})
		end,
		build = function()
			vim.fn.system({ "make", "install_jsregexp" })
		end,
		lazy = true,
	},

	-- Completion engine
	{
		"hrsh7th/cmp-nvim-lsp",
		dependencies = nil,
		init = nil,
		config = nil,
		build = nil,
		lazy = true,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "LuaSnip" },
		init = nil,
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = {
					-- stylua: ignore start
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(),                                                         { "i", "s", "c" }),
					["<C-n>"]     = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),         { "i", "s", "c" }),
					["<C-p>"]     = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),         { "i", "s", "c" }),
					["<C-y>"]     = cmp.mapping(cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }), { "i", "s", "c" }),
					["<C-e>"]     = cmp.mapping(cmp.mapping.abort(),                                                            { "i", "s", "c" }),
					["<Down>"]    = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),         { "i", "s" }),
					["<Up>"]      = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),         { "i", "s" }),
					["<CR>"]      = cmp.mapping(cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }), { "i", "s" }),
					-- stylua: ignore end
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = {
					{ name = "nvim_lsp" },
				},
			})
		end,
		build = nil,
		lazy = true,
		event = { "BufNewFile", "BufReadPre" },
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = { "cmp-nvim-lsp" },
		init = nil,
		config = function()
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			require("lspconfig")["pyright"].setup({
				capabilities = capabilities,
			})
		end,
		build = nil,
		lazy = true,
		event = { "BufNewFile", "BufReadPre" },
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "plenary.nvim" },
		init = nil,
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.black,
				},
			})
		end,
		build = nil,
		lazy = true,
		event = { "BufNewFile", "BufReadPre" },
	},

	-- Dependencies
	{
		"nvim-lua/plenary.nvim",
		dependencies = nil,
		init = nil,
		config = nil,
		build = nil,
		lazy = true,
	},
}, {
	install = { colorscheme = { "default" } }, -- https://github.com/folke/lazy.nvim/issues/713
})

--
-- Bindings
--

local binding = vim.keymap.set

binding({ "n", "v" }, "<leader><leader>", function()
	print(({ "󱢠", "󱢟", "󱀝", "󱢲" })[math.random(1, 4)])
end)
