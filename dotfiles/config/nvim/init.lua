vim.g.mapleader = " " -- Set global leader to space. Should be set before key bindings in order to take effect
vim.g.maplocalleader = " " -- Set local leader to space. Should be set before key bindings in order to take effect

vim.opt.expandtab = true -- Use the appropriate number of spaces to insert a <Tab>
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent

vim.opt.number = true -- Print the line number in front of each line
vim.opt.relativenumber = true -- Show the line number relative to the line with the cursor in front of each line

vim.opt.list = true -- Show non-printable characters. Recommended by Vim Galore
vim.opt.listchars = { tab = "→ ", space = "·" } -- Strings to use for non-printable characters

vim.opt.report = 0 -- Threshold for reporting number of lines changed. Recommended by Vim Galore

-- Allow switching your keyboard into a special language mode
vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯфисвуапршолдьтщзйкыегмцчня;ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
}
