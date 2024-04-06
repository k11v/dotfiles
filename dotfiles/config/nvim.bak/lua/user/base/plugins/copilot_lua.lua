local opts = {
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<M-C-y>",
			next = "<M-C-n>",
			prev = "<M-C-p>",
			dismiss = "<M-C-e>",
		},
	},
	filetypes = { ["*"] = true },
}

local config = function(_, opts)
	vim.g.copilot_proxy = "http://127.0.0.1:1081"

	-- Manually perform `require("copilot").setup()` to activate the panel
	-- and suggestions modules only when the Copilot client is attached
	-- (which means the Copilot server has been started and configured). This
	-- is necessary for the plugin to respect the proxy setting from the very
	-- beginning.
	--
	-- See:
	--
	-- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/init.lua
	-- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/command.lua
	require("copilot.config").setup(opts)
	require("copilot.highlight").setup()

	vim.api.nvim_create_autocmd({ "LspAttach" }, {
		group = vim.api.nvim_create_augroup("user_base_plugins_copilot_lua", {}),
		-- once = true,
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.name == "copilot" then
				require("copilot.panel").setup()
				require("copilot.suggestion").setup()
				require("copilot").setup_done = true

				vim.keymap.set({ "i" }, "<M-C-Space>", function()
					require("copilot.suggestion").toggle_auto_trigger()
				end, { silent = true })
				return true
			end
		end,
	})

	require("copilot.client").setup()
end

local plugin = {
	url = "https://github.com/zbirenbaum/copilot.lua",
	event = { "VeryLazy" }, -- TODO: Consider using `InsertEnter` instead
	opts = opts,
	config = config,
}

return { plugin }
