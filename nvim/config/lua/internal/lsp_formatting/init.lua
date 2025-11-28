local M = {}

M.setup = function(opts)
	-- Uses LSP starting.

	local lsp_server_formatting_arms = (opts or {}).lsp_server_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lsp_formatting", {}),
		callback = function(args)
			local client_ids = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, lsp_server_formatting_arms)) do
				local server = arm.key
				local enabled = arm.value

				if enabled then
					local client = vim.lsp.get_clients({ bufnr = args.buf, name = server })[1]
					if client then
						table.insert(client_ids, client.id)
					else
						vim.notify("failed to format with LSP server: client not found", vim.log.levels.ERROR)
					end
				end
			end

			if #client_ids > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						for _, client_id in ipairs(client_ids) do
							vim.lsp.buf.format({ id = client_id })
						end
					end,
				})

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.api.nvim_del_autocmd(autocmd)

						return true
					end,
				})
			end
		end,
	})
end

return M
