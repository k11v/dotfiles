-- Variables.

-- Set leaders.
vim.g.mapleader = "<Space>"
vim.g.maplocalleader = "<Space>"

-- Disable built-in plugins.
-- Plugins osc52.lua, nvim/net.lua cannot be disabled.
-- See $VIMRUNTIME/plugin.
vim.g.editorconfig = false -- editorconfig.lua
vim.g.loaded_2html_plugin = 1 -- tohtml.lua
vim.g.loaded_gzip = 1 -- gzip.vim
vim.g.loaded_man = 1 -- man.lua
vim.g.loaded_matchit = 1 -- matchit.vim
vim.g.loaded_matchparen = 1 -- matchparen.vim
vim.g.loaded_netrw = 1 -- netrwPlugin.vim
vim.g.loaded_netrwPlugin = 1 -- netrwPlugin.vim
vim.g.loaded_remote_plugins = 1 -- rplugin.vim
vim.g.loaded_shada_plugin = 1 -- shada.vim
vim.g.loaded_spellfile_plugin = 1 -- nvim/spellcheck.lua
vim.g.loaded_tar = 1 -- tarPlugin.vim
vim.g.loaded_tarPlugin = 1 -- tarPlugin.vim
vim.g.loaded_tutor_mode_plugin = 1 -- tutor.vim
vim.g.loaded_zip = 1 -- zipPlugin.vim
vim.g.loaded_zipPlugin = 1 -- zipPlugin.vim

-- Disable built-in plugin providers.
-- See *provider*.
vim.g.loaded_node_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_python3_provider = 1
vim.g.loaded_ruby_provider = 1

-- Options.

-- Disable 'wrapscan' to simplify automation with search.
-- You can wrap manually with "ggn".
vim.opt.wrapscan = false

vim.opt.timeout = false

vim.opt.signcolumn = "yes"

-- Disable 'hidden' to reduce buffer list pollution with modified buffers.
-- The default is on in Neovim and off in Vim.
--
-- When 'hidden' is disabled and buffer is abandoned,
-- it is unloaded and undo information is lost.
-- Enabling 'undofile' mitigates that.
vim.opt.hidden = false

-- Enable 'undofile' to persist undo information for unloaded buffers.
vim.opt.undofile = true

-- In Visual mode, don't allow cursor to be positioned on character past the line.
vim.opt.selection = "old"

-- In Visual block mode, allow cursor to be positioned where there is no actual character.
vim.opt.virtualedit = "block"

-- Other.

-- Mod and group.
local mod = "init"
local group = vim.api.nvim_create_augroup(mod, {})

-- Gopt and bopt.
vim.g.opt = {}
vim.cmd([[autocmd init FileType * lua vim.b.opt = {}]])

-- Gvar and bvar.
vim.g.var = {}
vim.cmd([[autocmd init FileType * lua vim.b.var = {}]])

--
-- Plugins
--

-- Lspconfig.
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- Conform.
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup()

--
-- Mods
--

-- Load mods.
for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/internal") do
	if type == "file" and name:match("%.lua$") then
		local mod = name:gsub("%.lua$", "")
		local modpath = "internal." .. mod
		package.loaded[modpath] = nil
		require(modpath)
	end
end

-- Test mods.
if vim.g.did_test == nil then
	for k, v in pairs(_G) do
		if string.sub(k, 1, 5) == "test_" then
			v()
		end
	end

	vim.g.did_test = true
end
