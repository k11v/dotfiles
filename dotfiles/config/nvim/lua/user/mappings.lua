vim.keymap.set({ "n" }, "<Esc>", function()
	vim.cmd.nohlsearch()
end, { silent = true })

vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
