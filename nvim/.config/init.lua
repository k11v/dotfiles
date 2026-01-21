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
vim.g.augroup = vim.api.nvim_create_augroup("g", {})

-- Gopt and bopt.
vim.g.opt = {}
vim.cmd([[autocmd g FileType * lua vim.b.opt = {}]])

-- Lspconfig.
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

-- Go gopls.
local gopls_cmd = {
	vim.fn.expand("~/.local/share/mise/installs/go-golang-org-x-tools-gopls/latest/bin/gopls"),
	unpack(vim.lsp.config["gopls"].cmd, 2),
}

local gopls_on_attach
do
	local on_attach = vim.lsp.config["gopls"].on_attach or function() end
	gopls_on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr)
	end
end

vim.lsp.config("gopls", {
	cmd = gopls_cmd,
	on_attach = gopls_on_attach,
	settings = {
		gopls = {
			buildFlags = { "-tags=dev,integration" }, -- temporary
			directoryFilters = { "-.git" },
			gofumpt = true,
			renameMovesSubpackages = true,
			semanticTokens = true,
			staticcheck = true,
			usePlaceholders = true,
			analyses = {
				S1011 = false, -- Use a single append to concatenate two slices
				ST1000 = false, -- Incorrect or missing package comment
				ST1003 = false, -- Poorly chosen identifier
				ST1022 = false, -- The documentation of an exported variable or constant should start with variable's name
				infertypeargs = false, -- check for unnecessary type arguments in call expressions -- temporary
				slicescontains = false, -- replace loops with slices.Contains or slices.ContainsFunc -- temporary
			},
		},
	}
})

vim.lsp.enable("gopls")

-- Go LSP formatting.
vim.cmd([[autocmd g BufWritePre *.go lua vim.lsp.buf.format({})]])
