return {
	name = "nvim",
	dir = vim.fn.stdpath("config"),
	opts = {
		x_inits = {
			{
				"*",
				function()
					vim.g.loaded_node_provider = 0
					vim.g.loaded_perl_provider = 0
					vim.g.loaded_python3_provider = 0
					vim.g.loaded_ruby_provider = 0

					vim.opt.breakindent = true
					vim.opt.colorcolumn = { "80" }
					vim.opt.cursorline = true
					vim.opt.cursorlineopt = "number"
					vim.opt.expandtab = true
					vim.opt.ignorecase = true
					vim.opt.inccommand = "split"
					vim.opt.mouse = "a"
					vim.opt.number = true
					vim.opt.report = 0
					vim.opt.scrolloff = 10
					vim.opt.shiftwidth = 4
					vim.opt.showmode = false
					vim.opt.signcolumn = "yes"
					vim.opt.shortmess:append({ I = true })
					vim.opt.smartcase = true
					vim.opt.softtabstop = 4
					vim.opt.splitbelow = true
					vim.opt.splitright = true
					vim.opt.tabstop = 4
					vim.opt.timeout = false
					vim.opt.undofile = true
					vim.opt.updatetime = 250

					vim.keymap.set({ "n" }, "<Esc>", function()
						vim.cmd.nohlsearch()
					end, { silent = true })

					vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
				end,
			},
		},
	},
}
