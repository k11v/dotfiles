local M = {}

M.setup = function(opts)
	-- Uses treesitter starting (?).

	local treesitter_folding_arms = (opts or {}).treesitter_folding_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_folding", {}),
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(require("internal.app").matches(args.buf, treesitter_folding_arms)) do
				enabled = arm.value
			end

			if enabled then
				vim.opt_local.foldmethod = "expr"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.opt_local.foldmethod = vim.opt_global.foldmethod:get()
						vim.opt_local.foldexpr = vim.opt_global.foldexpr:get()

						return true
					end,
				})
			end
		end,
	})
end

return M
