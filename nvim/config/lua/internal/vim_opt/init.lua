local M = {}

M.setup = function(opts)
	local vim_opt_arms = (opts or {}).vim_opt_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_opt", {}),
		callback = function(args)
			local vim_opts = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, vim_opt_arms)) do
				local name = arm.key
				local value = arm.value

				table.insert(vim_opts, { name = name, value = value })
			end

			for _, o in ipairs(vim_opts) do
				vim.opt_local[o.name] = o.value -- current buffer
			end

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "BufEnterPre " .. args.buf,
				callback = function()
					for _, o in ipairs(vim_opts) do
						vim.opt_local[o.name] = vim.opt_global[o.name]:get() -- current buffer
					end

					return true
				end,
			})
		end,
	})
end

return M
