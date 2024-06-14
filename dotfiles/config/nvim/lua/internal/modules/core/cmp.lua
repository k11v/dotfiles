local function maybe_complete()
	if require("cmp").visible() then
		return false
	end
	require("cmp").complete()
	return true
end

local function maybe_confirm()
	if not require("cmp").visible() then
		return false
	end
	require("cmp").confirm({ select = false })
	return true
end

local function maybe_abort()
	if not require("cmp").visible() then
		return false
	end
	require("cmp").abort()
	return true
end

local function maybe_select_item(direction)
	if not require("cmp").visible() then
		return false
	end
	if direction == 1 then
		require("cmp").select_next_item({ behavior = require("cmp").SelectBehavior.Insert })
	else
		require("cmp").select_prev_item({ behavior = require("cmp").SelectBehavior.Insert })
	end
	return true
end

local function maybe_scroll_docs(direction)
	if not require("cmp").visible() then
		return false
	end
	if direction == 1 then
		require("cmp").scroll_docs(4)
	else
		require("cmp").scroll_docs(-4)
	end
	return true
end

return {
	url = "https://github.com/hrsh7th/nvim-cmp",
	dependencies = { "cmp-nvim-lsp" },
	event = { "VeryLazy" },
	opts = {
		completion = {
			completeopt = "menu,menuone",
		},
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
		},
	},
	config = function(_, opts)
		require("cmp").setup(opts)

		vim.keymap.set({ "i" }, "<C-Space>", function()
			maybe_complete()
		end, { desc = "Show completion", silent = true })

		vim.keymap.set({ "i" }, "<C-y>", function()
			maybe_confirm()
		end, { desc = "Accept completion", silent = true })

		vim.keymap.set({ "i" }, "<C-e>", function()
			maybe_abort()
		end, { desc = "Hide completion", silent = true })

		vim.keymap.set({ "i" }, "<C-n>", function()
			if not maybe_select_item(1) then
				maybe_complete()
			end
		end, { desc = "Next completion", silent = true })

		vim.keymap.set({ "i" }, "<C-p>", function()
			if not maybe_select_item(-1) then
				maybe_complete()
			end
		end, { desc = "Previous completion", silent = true })

		vim.keymap.set({ "i" }, "<C-f>", function()
			maybe_scroll_docs(1)
		end, { desc = "Scroll down completion detail", silent = true })

		vim.keymap.set({ "i" }, "<C-b>", function()
			maybe_scroll_docs(-1)
		end, { desc = "Scroll up completion detail", silent = true })
	end,
}
