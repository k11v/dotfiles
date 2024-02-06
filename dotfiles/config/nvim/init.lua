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


vim.loader.enable()

local plugins_dir = vim.fn.stdpath("data") .. "/site/pack/dotfiles/opt"
if not vim.loop.fs_stat(plugins_dir) then
    print("Creating the plugins directory")
    vim.fn.system({ "mkdir", "-p", plugins_dir })
end


-- Syntax Highlighting

local should_update_nvim_treesitter_parsers = false

if not vim.loop.fs_stat(plugins_dir .. "/nvim-treesitter") then
    print("Installing nvim-treesitter/nvim-treesitter")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-treesitter/nvim-treesitter.git",
        plugins_dir .. "/nvim-treesitter",
    })
    should_update_nvim_treesitter_parsers = true
end

vim.cmd.packadd("nvim-treesitter")

require("nvim-treesitter.configs").setup({
    ensure_installed = {"markdown", "markdown_inline"},
    sync_install = true,
    auto_install = true,
    highlight = { enable = true },
})

if should_update_nvim_treesitter_parsers then
    print("Updating nvim-treesitter/nvim-treesitter parsers")
    vim.cmd.TSUpdate()
end


-- Color Scheme

if not vim.loop.fs_stat(plugins_dir .. "/tokyonight.nvim") then
    print("Installing folke/tokyonight.nvim")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/tokyonight.nvim.git",
        plugins_dir .. "/tokyonight.nvim",
    })
end

vim.cmd.packadd("tokyonight.nvim")

vim.cmd.colorscheme("tokyonight-night")
