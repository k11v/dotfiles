local servers_with_formatting = {} --[[@type { [string]: true }]]

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
	if
		client.supports_method("textDocument/formatting")
		and servers_with_formatting[client.name] ~= nil
	then
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = vim.api.nvim_create_augroup(
				"internal_lspconfig_bufwritepre_client" .. tostring(client.id) .. "_formatting",
				{}
			),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ id = client.id, bufnr = bufnr })
				vim.diagnostic.show() -- HACK: https://github.com/neovim/neovim/issues/25014
			end,
		})
	end

	vim.keymap.set({ "n" }, ",e", function()
		vim.diagnostic.open_float()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, ",q", function()
		vim.diagnostic.setloclist()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "K", function()
		vim.lsp.buf.hover()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, ",a", function()
		require("fzf-lua").lsp_code_actions()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, ",f", function()
		vim.lsp.buf.format()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, ",r", function()
		vim.lsp.buf.rename()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gD", function()
		require("fzf-lua").lsp_declarations({ jump_to_single_result = true })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gi", function()
		require("fzf-lua").lsp_implementations({ jump_to_single_result = true })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gr", function()
		require("fzf-lua").lsp_references()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gt", function()
		require("fzf-lua").lsp_typedefs({ jump_to_single_result = true })
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gs", function()
		require("fzf-lua").lsp_document_symbols()
	end, { buffer = bufnr, silent = true })

	vim.keymap.set({ "n" }, "gS", function()
		require("fzf-lua").lsp_live_workspace_symbols()
	end, { buffer = bufnr, silent = true })
end

return {
	url = "https://github.com/neovim/nvim-lspconfig",
	dependencies = { "cmp-nvim-lsp", "fzf-lua" },
	event = { "LazyFile", "VeryLazy" },
	opts_extend = { "x_inits", "x_servers.efm.x_tools" },
	opts = {
		---@type { [string]: table }
		x_servers = {
			efm = {
				---@type { [string]: table }[]
				x_tools = {},

				-- init_options contains all (at the time of writing) six capabilities.
				-- Whether efm will implement them or not is up to configured tools.
				init_options = {
					codeAction = true,
					completion = true,
					documentFormatting = true,
					documentRangeFormatting = true,
					documentSymbol = true,
					hover = true,
				},
				settings = {
					rootMarkers = { ".git/" },
				},

				---before_init relies on lspconfig keeping the extra fields while passing opts.
				---@param opts vim.lsp.ClientConfig|table
				---@return nil
				before_init = function(_, opts)
					local tools_from_language = {}
					for _, tool_from_language in ipairs(opts.x_tools) do
						for language, tool in pairs(tool_from_language) do
							tools_from_language[language] = tools_from_language[language] or {}
							table.insert(tools_from_language[language], tool)
						end
					end
					opts.x_tools = nil

					opts.filetypes = vim.tbl_keys(tools_from_language)
					opts.settings = opts.settings or {}
					opts.settings.languages = tools_from_language
				end,
			},
		},

		---@type fun()[]
		x_inits = {},
	},
	config = function(_, opts)
		for server, server_opts in pairs(opts.x_servers) do
			server_opts = vim.tbl_deep_extend(
				"force",
				{ capabilities = vim.lsp.protocol.make_client_capabilities() },
				{ capabilities = require("cmp_nvim_lsp").default_capabilities() }, -- TODO: check
				server_opts
			)

			local formatting = server_opts.x_formatting
			server_opts.x_formatting = nil
			if type(formatting) ~= "boolean" then
				if formatting ~= nil then
					vim.notify("lspconfig: x_formatting is not boolean", vim.log.levels.ERROR)
				end
				formatting = false
			end
			if formatting then
				servers_with_formatting[server] = true
			end

			local oa
			if server_opts.x_on_attach ~= nil then
				local x_on_attach = server_opts.x_on_attach
				server_opts.x_on_attach = nil
				oa = function(client, bufnr)
					local ft = vim.bo[bufnr].filetype
					local inner = x_on_attach[ft] or x_on_attach["*"] or function(_, _) end
					inner(client, bufnr)
					on_attach(client, bufnr)
				end
			elseif server_opts.on_attach ~= nil then
				local inner = server_opts.on_attach
				server_opts.on_attach = nil
				oa = function(client, bufnr)
					inner(client, bufnr)
					on_attach(client, bufnr)
				end
			else
				oa = on_attach
			end
			server_opts.on_attach = oa

			require("lspconfig")[server].setup(server_opts)
		end

		for _, i in ipairs(opts.x_inits) do
			i()
		end
	end,
}
