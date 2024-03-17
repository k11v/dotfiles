local opts = {
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
	},
}

local config_keymaps = function()
	local maybe_complete = function()
		if require("cmp").visible() then
			return false
		end
		require("cmp").complete()
		return true
	end

	local maybe_confirm = function()
		if not require("cmp").visible() then
			return false
		end
		require("cmp").confirm({ select = false })
		return true
	end

	local maybe_abort = function()
		if not require("cmp").visible() then
			return false
		end
		require("cmp").abort()
		return true
	end

	local maybe_select_item = function(direction)
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

	local maybe_scroll_docs = function(direction)
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

	vim.keymap.set({ "i" }, "<C-Space>", function()
		maybe_complete()
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-y>", function()
		maybe_confirm()
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-e>", function()
		maybe_abort()
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-n>", function()
		if not maybe_select_item(1) then
			maybe_complete()
		end
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-p>", function()
		if not maybe_select_item(-1) then
			maybe_complete()
		end
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-f>", function()
		maybe_scroll_docs(1)
	end, { silent = true })

	vim.keymap.set({ "i" }, "<C-b>", function()
		maybe_scroll_docs(-1)
	end, { silent = true })
end

local config = function(_, opts)
	require("cmp").setup(opts)
	config_keymaps()
end

local plugin = {
	url = "https://github.com/hrsh7th/nvim-cmp",
	dependencies = { "cmp-nvim-lsp", "LuaSnip" }, -- TODO: Consider removing `LuaSnip`
	event = { "VeryLazy" }, -- TODO: Consider using `InsertEnter` instead
	opts = opts,
	config = config,
}

return { plugin }
