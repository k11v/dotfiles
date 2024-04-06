vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.ignorecase = true
-- stylua: ignore
vim.opt.langmap = { "ЙQ", "ЦW", "УE", "КR", "ЕT", "НY", "ГU", "ШI", "ЩO", "ЗP", "Б{", "Х}", "ФA", "ЫS", "ВD", "АF", "ПG", "РH", "ОJ", "ЛK", "ДL", "Ж\\", "Э|", "ЯZ", "ЧX", "СC", "МV", "ИB", "ТN", "ЬM", "Ю`", "йq", "цw", "уe", "кr", "еt", "нy", "гu", "шi", "щo", "зp", "б[", "х]", "фa", "ыs", "вd", "аf", "пg", "рh", "оj", "лk", "дl", "ж^", "э$", "яz", "чx", "сc", "мv", "иb", "тn", "ьm", "ю&" }
vim.opt.langremap = false
vim.opt.report = 0
vim.opt.smartcase = true
vim.opt.timeout = false
vim.opt.updatetime = 250

-- stylua: ignore
vim.keymap.set({ "n" }, "<Esc>", function() vim.cmd.nohlsearch() end, { silent = true })
vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
