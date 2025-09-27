local deps_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"

if not vim.loop.fs_stat(deps_path) then
	vim.cmd('echo "Installing `mini.deps`" | redraw')
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.deps",
		deps_path,
	})
	vim.cmd("packadd mini.deps | helptags ALL")
	vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require("mini.deps").setup()

local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

-- Nvim

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.breakindent = true -- Enable break indent
vim.opt.colorcolumn = { "80" }
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.inccommand = "split" -- Preview substitutions live
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Make line numbers default
vim.opt.report = 0 -- always report changed lines
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.shortmess:append({ I = true }) -- don't give the intro message
vim.opt.smartcase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.splitbelow = true -- Configure how new splits should be opened
vim.opt.splitright = true -- Configure how new splits should be opened
vim.opt.timeout = false -- don't timeout when entering a sequence
vim.opt.undofile = true -- Save undo history
vim.opt.updatetime = 250 -- Decrease update time
-- vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim (new)
vim.opt.list = true -- Sets how neovim will display certain whitespace characters in the editor (new)
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Sets how neovim will display certain whitespace characters in the editor (new)
vim.o.confirm = true -- Raises a dialog asking if you wish to save the current file

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Highlighting, folding, indenting

vim.opt.foldlevelstart = 99
vim.opt.foldtext = ""

add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})

require("nvim-treesitter").install({ "go" }):wait(600000)

require("nvim-treesitter").install({ "markdown", "markdown_inline" }):wait(600000)

require("nvim-treesitter").install({ "lua" }):wait(600000)

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "go" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "go" },
	callback = function()
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "go" },
	callback = function()
		vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Editing

add({ source = "nvim-mini/mini.pairs" })

require("mini.pairs").setup()

add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
	},
})

vim.keymap.set({ "x", "o" }, "aa", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
	end)
end)
vim.keymap.set({ "x", "o" }, "ia", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
	end)
end)
vim.keymap.set({ "x", "o" }, "af", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
	end)
end)
vim.keymap.set({ "x", "o" }, "if", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
	end)
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
	end)
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	pcall(function()
		require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
	end)
end)

-- Formatting

add({ source = "stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].filetype == "lua" then
			require("conform").format({ bufnr = args.buf })
		end
	end,
})

-- Linting

add({ source = "mfussenegger/nvim-lint" })

require("lint").linters_by_ft = {
	go = { "golangcilint" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].filetype == "go" then
			require("lint").try_lint()
		end
	end,
})

-- LSP

add({ source = "neovim/nvim-lspconfig" })

vim.lsp.enable("gopls")
