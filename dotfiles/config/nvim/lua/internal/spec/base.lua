return {
	{
		"nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				inits_by_ft = {
					["*"] = vim.list_extend(opts.inits_by_ft["*"] or {}, {
						function()
							vim.opt.breakindent = true
							vim.opt.colorcolumn = { "80" }
							vim.opt.cursorline = true
							vim.opt.cursorlineopt = "number"
							vim.opt.expandtab = true
							vim.opt.ignorecase = true
							vim.opt.inccommand = "split"
							vim.opt.mouse = "a"
							vim.opt.number = true
							vim.opt.relativenumber = true
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
					}),
				},
			})
		end,
	},
}
