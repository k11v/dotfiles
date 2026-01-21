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

-- Other.

-- Augroup.
vim.g.augroup = vim.api.nvim_create_augroup("internal.augroup", {})

-- Gopt and bopt.
vim.g.opt = {}
vim.api.nvim_create_autocmd("FileType", { group = vim.g.augroup, callback = function() vim.b.opt = {} end })
