---@return nil
local function maybe_expand()
	if not require("luasnip").expandable() then
		return false
	end
	require("luasnip").expand()
	return true
end

---@param direction integer
---@return nil
local function maybe_jump(direction)
	if not require("luasnip").jumpable(direction) then
		return false
	end
	require("luasnip").jump(direction)
	return true
end

---@param direction integer
---@return nil
local function maybe_choose(direction)
	if not require("luasnip").choice_active() then
		return false
	end
	require("luasnip").change_choice(direction)
	return true
end

---@param keys string e.g. "<Tab>"
---@return nil
local function feedkeys(keys)
	local keys_with_replaced_termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys_with_replaced_termcodes, "n", false)
end

return {
	url = "https://github.com/L3MON4D3/LuaSnip",
	version = "v2.*",
	build = function()
		vim.fn.system({ "make", "install_jsregexp" })
	end,
	event = { "VeryLazy" },
	config = function(_, opts)
		require("luasnip").setup(opts)

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if not maybe_expand() then
				if not maybe_jump(1) then
					feedkeys("<Tab>")
				end
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			maybe_jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<M-Tab>", function()
			if not maybe_expand() then
				maybe_choose(1)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<S-M-Tab>", function()
			maybe_choose(-1)
		end, { silent = true })
	end,
}
