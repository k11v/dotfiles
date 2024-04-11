local config_keymaps = function()
	vim.keymap.set({ "n" }, ",,", function()
		require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
	end)

	vim.keymap.set({ "n" }, ",a", function()
		require("harpoon"):list():append()
	end)

	vim.keymap.set({ "n" }, ",!", function()
		require("harpoon"):list():select(1)
	end)

	vim.keymap.set({ "n" }, ",@", function()
		require("harpoon"):list():select(2)
	end)

	vim.keymap.set({ "n" }, ",#", function()
		require("harpoon"):list():select(3)
	end)

	vim.keymap.set({ "n" }, ",;", function()
		require("harpoon"):list():select(4)
	end)

	vim.keymap.set({ "n" }, ",[", function()
		require("harpoon"):list():prev()
	end)

	vim.keymap.set({ "n" }, ",]", function()
		require("harpoon"):list():next()
	end)
end

local config = function()
	require("harpoon").setup()
	config_keymaps()
end

local plugin = {
	url = "https://github.com/ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "plenary.nvim" },
	event = { "VeryLazy" },
	config = config,
}

return { plugin }
