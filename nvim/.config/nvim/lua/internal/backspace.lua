local mod = "backspace"

-- Shifted chars correspond to the Universal Layout.
local t = {
	{ "1", "!", "<Cmd>1argument<CR>", "Arg 1" },
	{ "2", "@", "<Cmd>2argument<CR>", "Arg 2" },
	{ "3", "#", "<Cmd>3argument<CR>", "Arg 3" },
	{ "4", ";", "<Cmd>4argument<CR>", "Arg 4" },
	{ "5", "%", "<Cmd>5argument<CR>", "Arg 5" },
	{ "6", ":", "<Cmd>6argument<CR>", "Arg 6" },
	{ "7", "?", "<Cmd>7argument<CR>", "Arg 7" },
	{ "8", "*", "<Cmd>8argument<CR>", "Arg 8" },
	{ "9", "(", "<Cmd>9argument<CR>", "Arg 9" },
	{ "0", ")", "<Cmd>$argument<CR>", "Arg last" },
	{ "t", nil, "<Cmd>edit x://term-adhoc<CR>", "Ad-hoc terminal" },
	{ "a", nil, "<Cmd>edit x://term-agent<CR>", "Agent terminal" },
}

for _, i in ipairs(t) do
	vim.keymap.set("n", "<BS>" .. i[1], i[3], { desc = i[4] })
	if i[2] then
		vim.keymap.set("n", "<BS>" .. i[2], i[3], { desc = i[4] })
	end
end
