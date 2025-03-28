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
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = function()
			vim.cmd.TSUpdate()
		end,
		init = function()
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
		init = function()
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
				tabline = {
					lualine_a = { "buffers" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "tabs" },
				},
			})
		end,
	},
	{
		url = "https://github.com/echasnovski/mini.nvim",
		lazy = false,
		init = function()
			require("mini.pairs").setup()
			require("mini.surround").setup()
		end,
	},
})
