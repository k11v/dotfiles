local treesitter_parsers = {}

local treesitter_highlighting_filetypes = {}

local treesitter_folding_filetypes = {}

local treesitter_indenting_filetypes = {}

return {
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
	setup_treesitter = function()
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
	end,
}
