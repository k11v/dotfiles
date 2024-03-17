local opts = {
	fzf_bin = "sk",
	winopts = {
		border = "single",
		preview = {
			title = false,
			scrollbar = false,
			delay = 10,
		},
	},
	previewers = {
		builtin = {
			extensions = {
				["jpg"] = { "chafa", "--symbols=solid" },
				["png"] = { "chafa", "--symbols=solid" },
				["svg"] = { "chafa", "--symbols=solid" },
			},
		},
	},
}

local config_keymaps = function()
	vim.keymap.set({ "n" }, "<leader><leader>", function()
		require("fzf-lua").buffers()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>sF", function()
		require("fzf-lua").files()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>sL", function()
		require("fzf-lua").live_grep_native()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>sf", function()
		require("fzf-lua").git_files()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>sh", function()
		require("fzf-lua").oldfiles()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>sl", function()
		require("fzf-lua").grep_curbuf()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>srf", function()
		require("fzf-lua").files({ resume = true })
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>srg", function()
		require("fzf-lua").live_grep_native({ resume = true })
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>srh", function()
		require("fzf-lua").oldfiles({ resume = true })
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>srr", function()
		require("fzf-lua").resume()
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>srs", function()
		require("fzf-lua").builtin({ resume = true })
	end, { silent = true })

	vim.keymap.set({ "n" }, "<leader>ss", function()
		require("fzf-lua").builtin()
	end, { silent = true })
end

local config = function(_, opts)
	require("fzf-lua").setup(opts)
	config_keymaps()
end

local plugin = {
	url = "https://github.com/ibhagwan/fzf-lua",
	dependencies = { "nvim-web-devicons" },
	event = { "VeryLazy" },
	opts = opts,
	config = config,
}

return { plugin }
