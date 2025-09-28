local setups_from_filetype = {}

local treesitter_parsers = {}

local treesitter_highlighting_filetypes = {}

local treesitter_folding_filetypes = {}

local treesitter_indenting_filetypes = {}

local lsp_servers = {}

return {
	setup_filetypes = function(filetypes, setup)
		for _, filetype in ipairs(filetypes) do
			setups_from_filetype[filetype] = setups_from_filetype[filetype] or {}
			table.insert(setups_from_filetype[filetype], setup)
		end
	end,
	treesitter_parsers = function(parsers)
		for _, parser in ipairs(parsers) do
			table.insert(treesitter_parsers, parser)
		end
	end,
	treesitter_highlighting_filetypes = function(filetypes)
		for _, filetype in ipairs(filetypes) do
			table.insert(treesitter_highlighting_filetypes, filetype)
		end
	end,
	treesitter_folding_filetypes = function(filetypes)
		for _, filetype in ipairs(filetypes) do
			table.insert(treesitter_folding_filetypes, filetype)
		end
	end,
	treesitter_indenting_filetypes = function(filetypes)
		for _, filetype in ipairs(filetypes) do
			table.insert(treesitter_indenting_filetypes, filetype)
		end
	end,
	lsp_servers = function(servers)
		for _, server in ipairs(servers) do
			table.insert(lsp_servers, server)
		end
	end,
	setup = function()
		-- Nvim

		vim.g.mapleader = " "
		vim.g.maplocalleader = " "

		vim.opt.breakindent = true
		vim.opt.clipboard = ""
		vim.opt.confirm = true
		vim.opt.cursorline = true
		vim.opt.cursorlineopt = "number"
		vim.opt.foldlevelstart = 99
		vim.opt.foldtext = ""
		vim.opt.ignorecase = true
		vim.opt.inccommand = "split"
		vim.opt.list = true
		vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
		vim.opt.mouse = "a"
		vim.opt.number = true
		vim.opt.report = 0
		vim.opt.scrolloff = 10
		vim.opt.shortmess:append({ I = true })
		vim.opt.showmode = false
		vim.opt.signcolumn = "yes"
		vim.opt.smartcase = true
		vim.opt.splitbelow = true
		vim.opt.splitright = true
		vim.opt.timeout = false
		vim.opt.undofile = true
		vim.opt.updatetime = 250

		vim.opt.colorcolumn = { "80" }
		vim.opt.expandtab = false
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 4
		vim.opt.tabstop = 4

		for filetype, setups in pairs(setups_from_filetype) do
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("internal_nvim_setup_" .. filetype, {}),
				pattern = filetype,
				callback = function()
					for _, setup in ipairs(setups) do
						setup()
					end
				end,
			})
		end

		-- Treesitter

		require("mini.deps").add({
			source = "https://github.com/nvim-treesitter/nvim-treesitter",
			checkout = "main",
			hooks = {
				post_checkout = function()
					vim.cmd("TSUpdate")
				end,
			},
		})

		require("mini.deps").add({
			source = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
			checkout = "main",
		})

		require("nvim-treesitter").install(treesitter_parsers):wait(10 * 60 * 1000)

		for _, filetype in ipairs(treesitter_highlighting_filetypes) do
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("internal_nvim_treesitter_highlighting_" .. filetype, {}),
				pattern = filetype,
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end

		for _, filetype in ipairs(treesitter_folding_filetypes) do
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("internal_nvim_treesitter_folding_" .. filetype, {}),
				pattern = filetype,
				callback = function()
					vim.opt_local.foldmethod = "expr"
					vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				end,
			})
		end

		for _, filetype in ipairs(treesitter_indenting_filetypes) do
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("internal_nvim_treesitter_indenting_" .. filetype, {}),
				pattern = filetype,
				callback = function()
					vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end

		-- LSP

		require("mini.deps").add({ source = "https://github.com/neovim/nvim-lspconfig" })

		vim.lsp.enable(lsp_servers)
	end,
}
