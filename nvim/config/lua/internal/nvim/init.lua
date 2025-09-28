local setups_from_filetype = {}

return {
	filetype_setup = function(filetype, setup)
		setups_from_filetype[filetype] = setups_from_filetype[filetype] or {}
		table.insert(setups_from_filetype[filetype], setup)
	end,
	setup = function()
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
	end,
}
