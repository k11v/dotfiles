local binding = vim.keymap.set

binding({ "n", "v" }, "<leader><leader>", function()
	print(({ "󱢠", "󱢟", "󱀝", "󱢲" })[math.random(1, 4)])
end)
