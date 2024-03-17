local build = function()
	vim.fn.system({ "make", "install_jsregexp" })
end

local config_snippets = function()
	local snippet = require("luasnip").snippet
	local extras = require("luasnip.extras")

	local s = require("luasnip").snippet_node
	local n = require("luasnip").indent_snippet_node
	local t = require("luasnip").text_node
	local i = require("luasnip").insert_node
	local f = require("luasnip").function_node
	local c = require("luasnip").choice_node
	local d = require("luasnip").dynamic_node
	local r = require("luasnip").restore_node

	require("luasnip").add_snippets("all", {
		snippet("now", { extras.partial(os.date, "!%Y-%m-%dT%H:%M:%SZ") }),
	})
end

local config_keymaps = function()
	local maybe_expand = function()
		if not require("luasnip").expandable() then
			return false
		end
		require("luasnip").expand()
		return true
	end

	local maybe_jump = function(direction)
		if not require("luasnip").jumpable(direction) then
			return false
		end
		require("luasnip").jump(direction)
		return true
	end

	local maybe_choose = function(direction)
		if not require("luasnip").choice_active() then
			return false
		end
		require("luasnip").change_choice(direction)
		return true
	end

	vim.keymap.set({ "i", "s" }, "<Tab>", function()
		if not maybe_expand() then
			maybe_jump(1)
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
end

local config = function()
	config_snippets()
	config_keymaps()
end

local plugin = {
	url = "https://github.com/L3MON4D3/LuaSnip",
	version = "v2.*",
	build = build,
	config = config,
}

return { plugin }
