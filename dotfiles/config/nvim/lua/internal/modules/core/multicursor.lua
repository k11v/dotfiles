return {
	url = "https://github.com/jake-stewart/multicursor.nvim",
	branch = "1.0",
	event = { "VeryLazy" },
	config = function(_, opts)
		require("multicursor-nvim").setup(opts)

		-- Easy way to add and remove cursors using the main cursor.
		vim.keymap.set(
			{ "n", "v" },
			"Q",
			require("multicursor-nvim").toggleCursor,
			{ silent = true }
		)

		-- Add and remove cursors with control + left click.
		vim.keymap.set(
			{ "n" },
			"<C-LeftMouse>",
			require("multicursor-nvim").handleMouse,
			{ silent = true }
		)

		-- Add a new cursor by matching word/selection.
		vim.keymap.set({ "v" }, "<C-n>", function()
			require("multicursor-nvim").matchAddCursor(1)
		end, { silent = true })
		vim.keymap.set({ "v" }, "<C-S-n>", function()
			require("multicursor-nvim").matchAddCursor(-1)
		end, { silent = true })

		-- Add all matches in the file.
		vim.keymap.set(
			{ "n", "v" },
			"ma",
			require("multicursor-nvim").matchAllAddCursors,
			{ silent = true }
		)

		-- -- Add cursors with any motion you prefer.
		-- vim.keymap.set({ "n" }, "<right>", function()
		-- 	require("multicursor-nvim").addCursor("w")
		-- end, { silent = true })
		-- vim.keymap.set({ "n" }, "<leader><right>", function()
		-- 	require("multicursor-nvim").skipCursor("w")
		-- end, { silent = true })

		-- Rotate the main cursor.
		vim.keymap.set(
			{ "n", "v" },
			"<Down>",
			require("multicursor-nvim").nextCursor,
			{ silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<Up>",
			require("multicursor-nvim").prevCursor,
			{ silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<Right>",
			require("multicursor-nvim").nextCursor,
			{ silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<Left>",
			require("multicursor-nvim").prevCursor,
			{ silent = true }
		)

		-- Delete the main cursor.
		vim.keymap.set(
			{ "n", "v" },
			"mx",
			require("multicursor-nvim").deleteCursor,
			{ silent = true }
		)

		-- Enable disabled cursors, clear enabled cursors, or do the default.
		vim.keymap.set({ "n" }, "<Esc>", function()
			if not require("multicursor-nvim").cursorsEnabled() then
				require("multicursor-nvim").enableCursors()
			elseif require("multicursor-nvim").hasCursors() then
				require("multicursor-nvim").clearCursors()
			else
				-- default <Esc> handler
				vim.cmd.nohlsearch()
			end
		end, { silent = true })

		-- Bring back cursors if you accidentally clear them.
		vim.keymap.set({ "n" }, "mu", require("multicursor-nvim").restoreCursors, { silent = true })

		-- Split visual selections by regex.
		vim.keymap.set({ "v" }, "S", require("multicursor-nvim").splitCursors, { silent = true })

		-- Match new cursors within visual selections by regex.
		vim.keymap.set({ "v" }, "M", require("multicursor-nvim").matchCursors, { silent = true })

		-- Append/insert for each line of visual selections.
		vim.keymap.set({ "v" }, "I", require("multicursor-nvim").insertVisual, { silent = true })
		vim.keymap.set({ "v" }, "A", require("multicursor-nvim").appendVisual, { silent = true })

		-- Rotate visual selection contents.
		vim.keymap.set({ "v" }, "mt", function()
			require("multicursor-nvim").transposeCursors(1)
		end, { silent = true })
		vim.keymap.set({ "v" }, "mT", function()
			require("multicursor-nvim").transposeCursors(-1)
		end, { silent = true })

		-- Clone every cursor and disable the originals. (I didn't find use.)
		vim.keymap.set(
			{ "n", "v" },
			"mQ",
			require("multicursor-nvim").duplicateCursors,
			{ silent = true }
		)

		-- Align cursor columns. (I didn't find use.)
		vim.keymap.set({ "v" }, "mA", require("multicursor-nvim").alignCursors, { silent = true })

		-- Jumplist support.
		vim.keymap.set(
			{ "v", "n" },
			"<C-i>",
			require("multicursor-nvim").jumpForward,
			{ silent = true }
		)
		vim.keymap.set(
			{ "v", "n" },
			"<C-o>",
			require("multicursor-nvim").jumpBackward,
			{ silent = true }
		)

		-- Customize how cursors look.
		vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
		vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
