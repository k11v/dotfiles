local mod = "backspace"

-- Shifted chars correspond to the Universal Layout.
local t = {
	-- Args
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

	-- Terms
	{ "q", nil, "<Cmd>edit x://term/q<CR>", "Term q" },
	{ "w", nil, "<Cmd>edit x://term/w<CR>", "Term w" },
	{ "e", nil, "<Cmd>edit x://term/e<CR>", "Term e" },
	{ "r", nil, "<Cmd>edit x://term/r<CR>", "Term r" },
	{ "t", nil, "<Cmd>edit x://term/t<CR>", "Term t" },
	{ "y", nil, "<Cmd>edit x://term/y<CR>", "Term y" },
	{ "u", nil, "<Cmd>edit x://term/u<CR>", "Term u" },
	{ "i", nil, "<Cmd>edit x://term/i<CR>", "Term i" },
	{ "o", nil, "<Cmd>edit x://term/o<CR>", "Term o" },
	{ "p", nil, "<Cmd>edit x://term/p<CR>", "Term p" },

	-- Agents
	{ "a", nil, "<Cmd>edit x://agent/a<CR>", "Agent a" },
	{ "s", nil, "<Cmd>edit x://agent/s<CR>", "Agent s" },
	{ "d", nil, "<Cmd>edit x://agent/d<CR>", "Agent d" },
	{ "f", nil, "<Cmd>edit x://agent/f<CR>", "Agent f" },
	{ "g", nil, "<Cmd>edit x://agent/g<CR>", "Agent g" },
	{ "h", nil, "<Cmd>edit x://agent/h<CR>", "Agent h" },
	{ "j", nil, "<Cmd>edit x://agent/j<CR>", "Agent j" },
	{ "k", nil, "<Cmd>edit x://agent/k<CR>", "Agent k" },
	{ "l", nil, "<Cmd>edit x://agent/l<CR>", "Agent l" },
}

for _, i in ipairs(t) do
	vim.keymap.set("n", "<BS>" .. i[1], i[3], { desc = i[4] })
	if i[2] then
		vim.keymap.set("n", "<BS>" .. i[2], i[3], { desc = i[4] })
	end
end
