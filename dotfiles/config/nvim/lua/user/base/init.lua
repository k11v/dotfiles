local M = {}

local setup_variables = function()
	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_python3_provider = 0
	vim.g.loaded_ruby_provider = 0
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
end

local setup_options = function()
	vim.opt.breakindent = true
	vim.opt.colorcolumn = { "80" }
	vim.opt.cursorline = true
	vim.opt.cursorlineopt = "number"
	vim.opt.expandtab = true
	vim.opt.ignorecase = true
	vim.opt.inccommand = "split"
	-- stylua: ignore
	vim.opt.langmap = { "ЙQ", "ЦW", "УE", "КR", "ЕT", "НY", "ГU", "ШI", "ЩO", "ЗP", "Б{", "Х}", "ФA", "ЫS", "ВD", "АF", "ПG", "РH", "ОJ", "ЛK", "ДL", "Ж\\", "Э|", "ЯZ", "ЧX", "СC", "МV", "ИB", "ТN", "ЬM", "Ю`", "йq", "цw", "уe", "кr", "еt", "нy", "гu", "шi", "щo", "зp", "б[", "х]", "фa", "ыs", "вd", "аf", "пg", "рh", "оj", "лk", "дl", "ж^", "э$", "яz", "чx", "сc", "мv", "иb", "тn", "ьm", "ю&" }
	vim.opt.langremap = false
	vim.opt.listchars = { tab = "→ ", space = "·" }
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
end

local setup_keymaps = function()
	vim.keymap.set({ "n" }, "<Esc>", function()
		vim.cmd.nohlsearch()
	end, { silent = true })

	vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
end

M.setup = function()
	setup_variables()
	setup_options()
	setup_keymaps()
end

M.get_plugins = function(module)
	return { { import = module .. ".plugins" } }
end

return M
