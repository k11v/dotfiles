return {
	url = "https://github.com/neovim/nvim-lspconfig",
	dependencies = { "fzf-lua" },
	event = { "LazyFile", "VeryLazy" },
	opts_extend = { "x_inits", "x_servers.efm.x_tools" },
	opts = {
		x_inits = {},
		x_servers = {
			efm = {
				x_tools = {},
				-- x_on_attach = {
				--  ["*"] = function() end,
				-- },
				settings = {
					rootMarkers = { ".git/" },
					init_options = {
						documentFormatting = true,
						documentRangeFormatting = true,
					},
				},
			},
		},
	},
	config = function(_, opts)
		local default_server_opts = {
			capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities()
				-- require("cmp_nvim_lsp").default_capabilities() -- TODO
			),
		}

		for server, server_opts in pairs(opts.x_servers) do
			local server_opts = vim.tbl_deep_extend("force", default_server_opts, server_opts)

			if server == "efm" then
				local language_to_tools = {}
				for _, language_and_tool in ipairs(server_opts.x_tools) do
					local language, tool = language_and_tool[1], language_and_tool[2]
					language_to_tools[language] = language_to_tools[language] or {}
					table.insert(language_to_tools[language], tool)
				end
				server_opts.x_tools = nil

				server_opts = vim.tbl_deep_extend("force", server_opts, {
					filetypes = vim.tbl_keys(language_to_tools),
					settings = {
						languages = language_to_tools,
					},
				})
			end

			if server_opts.x_on_attach then
				local x_on_attach = server_opts.x_on_attach

				server_opts = vim.tbl_deep_extend("force", server_opts, {
					on_attach = function(client, bufnr)
						local ft = vim.bo[bufnr].filetype
						local handler = x_on_attach[ft] or x_on_attach["*"] or function() end
						handler(client, bufnr)
					end,
				})
			end

			require("lspconfig")[server].setup(server_opts)
		end

		vim.api.nvim_create_autocmd({ "LspAttach" }, {
			group = vim.api.nvim_create_augroup("internal_lspconfig_lspattach", {}),
			callback = function(event)
				vim.keymap.set({ "n" }, "<leader>e", function()
					vim.diagnostic.open_float()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "[d", function()
					vim.diagnostic.goto_prev()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "]d", function()
					vim.diagnostic.goto_next()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "<leader>q", function()
					vim.diagnostic.setloclist()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "K", function()
					vim.lsp.buf.hover()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "<leader>a", function()
					require("fzf-lua").lsp_code_actions()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "<leader>f", function()
					vim.lsp.buf.format()
				end, { buffer = event.buf, silent = true })

				vim.keymap.set({ "n" }, "<leader>r", function()
					vim.lsp.buf.rename()
				end, { buffer = event.buf, silent = true })

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

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd({ "BufWritePre" }, {
						group = vim.api.nvim_create_augroup("internal_lspconfig_bufwritepre", {}),
						buffer = event.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = event.buf })
							vim.diagnostic.show() -- HACK: https://github.com/neovim/neovim/issues/25014
						end,
					})
				end
			end,
		})

		for _, i in ipairs(opts.x_inits) do
			i()
		end
	end,
}
