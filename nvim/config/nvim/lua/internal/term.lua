local mod = "term"

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", [[<C-\><Esc>]], "<Esc>", { desc = "Send Esc to terminal" })

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:nt",
	callback = function()
		vim.wo.cursorline = true
		vim.wo.cursorcolumn = true
	end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "nt:*",
	callback = function()
		vim.wo.cursorline = false
		vim.wo.cursorcolumn = false
	end,
})
