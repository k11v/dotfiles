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
	vim.print("Installing lazy")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	})
	vim.print("Installed lazy")
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
	-- Snippets
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

	-- Completion
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = nil,
		init = nil,
		config = nil,
		build = nil,
		lazy = true,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "LuaSnip", "cmp_luasnip" },
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
					{ name = "luasnip" },
				},
			})
		end,
		build = nil,
		lazy = true,
		event = { "BufNewFile", "BufReadPre" },
	},

	-- Tools
	{
		"williamboman/mason.nvim",
		dependencies = nil,
		init = nil,
		config = function()
			require("mason").setup()
		end,
		build = function()
			vim.cmd.MasonUpdate()
		end,
		lazy = false, -- Lazy-loading Mason is not recommended.
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		init = nil,
		config = function()
			require("mason-lspconfig").setup()
		end,
		build = nil,
		lazy = true,
	},
})

--
-- Bindings
--

local binding = vim.keymap.set

binding({ "n", "v" }, "<leader><leader>", function()
	print(({ "󱢠", "󱢟", "󱀝", "󱢲" })[math.random(1, 4)])
end)
