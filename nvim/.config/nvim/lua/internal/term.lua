local mod = "term"

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", [[<C-\><Esc>]], "<Esc>", { desc = "Send Esc to terminal" })
