local M = {}

M.setup = function(opts)
	-- TODO: Consider buffers with physical files.

	-- TODO: Consider stopping LSP servers that weren't used in 1 hour.

	-- TODO: Check filetypes of the LSP config (from nvim-lspconfig)
	-- and hint that some filetypes might be extra/missing.

	local lsp_server_arms = (opts or {}).lsp_server_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lsp_starting", {}),
		callback = function(args)
			local client_ids = {}
			local initialized_from_i = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, lsp_server_arms)) do
				local server = arm.key
				local config
				local enabled

				-- TODO: When vim.lsp.config[server] is nil, errors aren't really clear.

				if type(arm.value) == "table" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					config = vim.tbl_deep_extend("force", config, arm.value)
					enabled = true
				elseif type(arm.value) == "function" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					config = arm.value(config) or {}
					enabled = true
				elseif type(arm.value) == "boolean" then
					config = vim.deepcopy(vim.lsp.config[server] or {})
					enabled = arm.value
				end

				if enabled then
					-- TODO: Maybe config.on_init could be a list of functions?
					local i = #client_ids + 1
					initialized_from_i[i] = false
					local on_init = config.on_init or function() end
					config.on_init = function(client, init_result)
						on_init(client, init_result)
						initialized_from_i[i] = true
					end

					local client_id = vim.lsp.start(config, {
						reuse_client = nil,
						bufnr = bufnr,
						attach = false,
					})

					if vim.lsp.get_client_by_id(client_id).initialized then
						initialized_from_i[i] = true
					end

					table.insert(client_ids, client_id)
				end
			end

			if #client_ids > 0 then
				local ok = vim.wait(1 * 1000, function()
					local initialized = true
					for i = 1, #client_ids do
						initialized = initialized and initialized_from_i[i]
					end
					return initialized
				end, 10)

				if not ok then
					for _, client_id in ipairs(client_ids) do
						vim.lsp.stop_client(client_id, true) -- force means SIGTERM but it is probably an implementation detail
					end
					vim.notify("failed to start LSP servers: timeout exceeded", vim.log.levels.ERROR)
				end
			end

			if #client_ids > 0 then
				for _, client_id in ipairs(client_ids) do
					vim.lsp.buf_attach_client(args.buf, client_id)
				end

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						for _, client_id in ipairs(client_ids) do
							vim.lsp.buf_detach_client(args.buf, client_id)
						end

						return true
					end,
				})
			end
		end,
	})
end

return M
