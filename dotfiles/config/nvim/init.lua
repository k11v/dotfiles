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

require("lazy").setup({})

--
-- Bindings
--

local binding = vim.keymap.set

binding({ "n", "v" }, "<leader><leader>", function()
	print(({ "󱢠", "󱢟", "󱀝", "󱢲" })[math.random(1, 4)])
end)
