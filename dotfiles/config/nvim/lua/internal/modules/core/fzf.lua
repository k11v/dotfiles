return {
	url = "https://github.com/ibhagwan/fzf-lua",
	dependencies = { "nvim-web-devicons" },
	event = "VeryLazy",
	opts = {
		winopts = {
			border = "single",
			preview = {
				title = false,
				scrollbar = false,
				delay = 10,
			},
		},
	},
	config = function(_, opts)
		require("fzf-lua").setup(opts)

		vim.keymap.set({ "n" }, "<leader>sL", function()
			require("fzf-lua").live_grep_native()
		end, { silent = true })

		vim.keymap.set({ "n" }, "<leader>sb", function()
			require("fzf-lua").buffers()
		end, { silent = true })

		vim.keymap.set({ "n" }, "<leader>sf", function()
			require("fzf-lua").files()
		end, { silent = true })

		vim.keymap.set({ "n" }, "<leader>sh", function()
			require("fzf-lua").oldfiles()
		end, { silent = true })

		vim.keymap.set({ "n" }, "<leader>sl", function()
			require("fzf-lua").grep_curbuf()
		end, { silent = true })

		vim.keymap.set({ "n" }, "<leader>ss", function()
			require("fzf-lua").builtin()
		end, { silent = true })
	end,
}
