local opts = {
	x_servers = {},
}

local config_keymaps = function()
	vim.keymap.set({ "n" }, "<leader>e", vim.diagnostic.open_float, { silent = true })

	vim.keymap.set({ "n" }, "[d", vim.diagnostic.goto_prev, { silent = true })

	vim.keymap.set({ "n" }, "]d", vim.diagnostic.goto_next, { silent = true })

	vim.keymap.set({ "n" }, "<leader>q", vim.diagnostic.setloclist, { silent = true })

	vim.api.nvim_create_autocmd({ "LspAttach" }, {
		group = vim.api.nvim_create_augroup("user_base_plugins_nvim_lspconfig", {}),
		callback = function(event)
			-- vim.keymap.set({ "n" }, "<C-k>", vim.lsp.buf.signature_help, { buffer = event.buf, silent = true })

			-- TODO: Try code actions with `previewer=codeaction_native`
			vim.keymap.set({ "n" }, "<leader>aa", function()
				require("fzf-lua").lsp_code_actions()
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "<leader>af", vim.lsp.buf.format, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "<leader>ar", vim.lsp.buf.rename, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gD", function()
				require("fzf-lua").lsp_declarations({ jump_to_single_result = true })
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gd", function()
				require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gi", function()
				require("fzf-lua").lsp_implementations({ jump_to_single_result = true })
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gr", function()
				require("fzf-lua").lsp_references()
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gt", function()
				require("fzf-lua").lsp_typedefs({ jump_to_single_result = true })
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gs", function()
				require("fzf-lua").lsp_document_symbols()
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "gS", function()
				require("fzf-lua").lsp_live_workspace_symbols()
			end, { buffer = event.buf, silent = true })

			vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = event.buf, silent = true })
		end,
	})
end

local config = function(_, opts)
	local capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	)

	for server, server_opts in pairs(opts.x_servers) do
		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = vim.deepcopy(capabilities),
		}, server_opts)

		require("lspconfig")[server].setup(server_opts)
	end

	config_keymaps()
end

local plugin = {
	url = "https://github.com/neovim/nvim-lspconfig",
	dependencies = { "cmp-nvim-lsp" }, -- Also depends on `fzf-lua`
	event = { "LazyFile" },
	opts = opts,
	config = config,
}

return { plugin }
