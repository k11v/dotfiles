local mod = "term"

-- <Esc> exits terminal mode. Use <C-\><Esc> to send a raw Esc to the terminal.
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
