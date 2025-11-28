local M = {}

M.setup = function(opts)
	-- TODO: Improve UX when formatter name is misspelled or nonexistent.
	-- Right now it sends errors to messages.
	-- Ideally we don't show any errors and a command like "doctor" tells what's wrong.

	-- TODO: Improve UX when formatter command is not installed.

	-- TODO: The PWD where the formatter is started might be important.

	local conform_formatter_formatting_arms = (opts or {}).conform_formatter_formatting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.conform_formatting", {}),
		callback = function(args)
			local formatters = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, conform_formatter_formatting_arms)) do
				local formatter = arm.key
				local enabled = arm.value

				if enabled then
					table.insert(formatters, formatter)
				end
			end

			if #formatters > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
					buffer = args.buf,
					callback = function()
						for _, formatter in ipairs(formatters) do
							require("conform").format({
								bufnr = args.buf,
								formatters = { formatter },
								timeout_ms = 1 * 1000,
							})
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
