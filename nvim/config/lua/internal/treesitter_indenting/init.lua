local M = {}

M.setup = function(opts)
	-- Uses treesitter starting (?).

	-- Uses nvim-treesitter.

	local treesitter_indenting_arms = (opts or {}).treesitter_indenting_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_indenting", {}),
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(require("internal.app").matches(args.buf, treesitter_indenting_arms)) do
				enabled = arm.value
			end

			if enabled then
				vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.opt_local.indentexpr = vim.opt_global.indentexpr:get()

						return true
					end,
				})
			end
		end,
	})
end

return M
