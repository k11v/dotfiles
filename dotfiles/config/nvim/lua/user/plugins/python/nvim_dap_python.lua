local config_keymaps = function()
	vim.keymap.set({ "n" }, "<leader>df", function()
		require("dap-python").test_method()
	end, { silent = true })
end

local config = function()
	require("dap-python").setup("~/.local/share/venv/venvs/debugpy/bin/python")
	require("dap-python").test_runner = "pytest"
	config_keymaps()
end

local plugin = {
	url = "https://github.com/mfussenegger/nvim-dap-python",
	ft = { "python" },
	config = config,
}

return plugin
