local mod = "arglist"

local t = {
	{ "1", "1", "1" },
	{ "2", "2", "2" },
	{ "3", "3", "3" },
	{ "4", "4", "4" },
	{ "5", "5", "5" },
	{ "6", "6", "6" },
	{ "7", "7", "7" },
	{ "8", "8", "8" },
	{ "9", "$", "last" },
	{ "0", "0", "first" },
}

for _, i in ipairs(t) do
	vim.keymap.set("n", "<BS>" .. i[1], "<Cmd>" .. i[2] .. "argument<CR>", { desc = "Go to " .. i[3] .. " arg" })
end

for _, i in ipairs(t) do
	vim.keymap.set("n", "<BS>a" .. i[1], "<Cmd>" .. i[2] .. "argadd<CR>", { desc = "Add after " .. i[3] .. " arg" })
end

for _, i in ipairs(t) do
	vim.keymap.set("n", "<BS>d" .. i[1], "<Cmd>" .. i[2] .. "argdelete<CR>", { desc = "Delete " .. i[3] .. " arg" })
end
