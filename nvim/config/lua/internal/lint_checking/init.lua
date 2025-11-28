local M = {}

M.setup = function(opts)
	-- TODO: Improve UX when linter name is misspelled or nonexistent.
	-- Right now it sends errors to messages.
	-- Ideally we don't show any errors and a command like "doctor" tells what's wrong.

	-- TODO: Improve UX when linter command is not installed.

	-- TODO: The PWD where the linter is started might be important.

	local lint_linter_checking_arms = (opts or {}).lint_linter_checking_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.lint_checking", {}),
		callback = function(args)
			local linters = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, lint_linter_checking_arms)) do
				local linter = arm.key
				local enabled = arm.value

				if enabled then
					table.insert(linters, linter)
				end
			end

			if #linters > 0 then
				local autocmd = vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					buffer = args.buf,
					callback = function()
						for _, linter in ipairs(linters) do
							require("lint").try_lint(linter) -- current buffer
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
