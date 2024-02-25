vim.g.mapleader = " " -- Set global leader to space. Should be set before key bindings in order to take effect
vim.g.maplocalleader = " " -- Set local leader to space. Should be set before key bindings in order to take effect

vim.opt.expandtab = true -- Use the appropriate number of spaces to insert a <Tab>
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent

vim.opt.number = true -- Print the line number in front of each line
vim.opt.relativenumber = true -- Show the line number relative to the line with the cursor in front of each line
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.cursorlineopt = "number" -- Make 'cursorline' highlight only the line number of the cursor

vim.opt.listchars = { tab = "→ ", space = "·" } -- Strings to use for non-printable characters when they are shown using ':set list'

vim.opt.report = 0 -- Threshold for reporting number of lines changed. Recommended by Vim Galore

-- Allow switching your keyboard into a special language mode
vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯфисвуапршолдьтщзйкыегмцчня;ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
}

vim.opt.shellcmdflag = "-i " .. vim.opt.shellcmdflag:get() -- Use interactive shell for :!

vim.opt.timeout = false -- Disable mapped key sequence timeout

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>D", '"+D', { silent = true })

--
-- Plugins
--

local lazy_dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_dir) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		lazy_dir,
	})
end

vim.opt.rtp:prepend(lazy_dir)

require("lazy").setup({
	{
		url = "https://github.com/folke/tokyonight.nvim",
		lazy = false,
		priority = math.huge,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = function()
			vim.cmd.TSUpdate()
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "query", "vim", "vimdoc" }, -- Replace Neovim's built-in parsers with nvim-treesitter's own compatible parsers -- TODO: Add other parsers via modules (e.g. the Python module should add "python", the Markdown module should add "markdown", "markdown_inline", "html", etc.)
				auto_install = true,
				highlight = { enable = true },
			})
		end,
	},
	{
		url = "https://github.com/nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		url = "https://github.com/echasnovski/mini.nvim",
		lazy = false,
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		url = "https://github.com/ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				fzf_bin = "sk",
				winopts = {
					border = "single",
					preview = {
						title = false,
						scrollbar = false,
						delay = 10,
					},
				},
				previewers = {
					builtin = {
						extensions = {
							["jpg"] = { "chafa", "--symbols=solid" },
							["png"] = { "chafa", "--symbols=solid" },
							["svg"] = { "chafa", "--symbols=solid" },
						},
					},
				},
			})

			vim.keymap.set({ "n" }, "<leader>b", function()
				require("fzf-lua").buffers()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>f", function()
				require("fzf-lua").files()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>h", function()
				require("fzf-lua").oldfiles()
			end, { silent = true })
			vim.keymap.set({ "n" }, "<leader>g", function()
				require("fzf-lua").live_grep()
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = false,
		build = function()
			vim.fn.system({ "make", "install_jsregexp" })
		end,
		config = function()
			require("init_luasnip_snippets")

			local maybe_expand = function()
				if not require("luasnip").expandable() then
					return false
				end
				require("luasnip").expand()
				return true
			end

			local maybe_jump = function(direction)
				if not require("luasnip").jumpable(direction) then
					return false
				end
				require("luasnip").jump(direction)
				return true
			end

			local maybe_choose = function(direction)
				if not require("luasnip").choice_active() then
					return false
				end
				require("luasnip").change_choice(direction)
				return true
			end

			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if not maybe_expand() then
					maybe_jump(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				maybe_jump(-1)
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<M-Tab>", function()
				if not maybe_expand() then
					maybe_choose(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<S-M-Tab>", function()
				maybe_choose(-1)
			end, { silent = true })
		end,
	},
	{
		url = "https://github.com/hrsh7th/cmp-nvim-lsp",
		lazy = false,
	},
	{
		url = "https://github.com/neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "https://github.com/hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("lspconfig").pyright.setup({ capabilities = capabilities })
		end,
	},
	{
		url = "https://github.com/hrsh7th/nvim-cmp",
		lazy = false,
		config = function()
			require("cmp").setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
				},
			})

			vim.keymap.set({ "i" }, "<C-Space>", function()
				if not require("cmp").visible() then
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-n>", function()
				if require("cmp").visible() then
					require("cmp").select_next_item({ behavior = require("cmp").SelectBehavior.Insert })
				else
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-p>", function()
				if require("cmp").visible() then
					require("cmp").select_prev_item({ behavior = require("cmp").SelectBehavior.Insert })
				else
					require("cmp").complete()
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-b>", function()
				if require("cmp").visible() then
					require("cmp").scroll_docs(-4)
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-f>", function()
				if require("cmp").visible() then
					require("cmp").scroll_docs(4)
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-y>", function()
				if require("cmp").visible() then
					require("cmp").confirm({ select = false })
				end
			end, { silent = true })

			vim.keymap.set({ "i" }, "<C-e>", function()
				if require("cmp").visible() then
					require("cmp").abort()
				end
			end, { silent = true })
		end,
	},
})
