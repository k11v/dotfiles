local M = {}

M.setup = function(opts)
	local vim_keymap_arms = (opts or {}).vim_keymap_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_keymap", {}),
		callback = function(args)
			local keymaps = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, vim_keymap_arms)) do
				local mode = arm.key[1]
				local lhs = arm.key[2]
				local rhs = arm.value[1]
				local desc = arm.value[2]

				if type(rhs) == "string" or type(rhs) == "function" then
					table.insert(keymaps, { mode = mode, lhs = lhs, rhs = rhs, desc = desc })
				end
			end

			for _, k in ipairs(keymaps) do
				vim.keymap.set(k.mode, k.lhs, k.rhs, { desc = k.desc, buffer = args.buf })
			end

			vim.api.nvim_create_autocmd({ "BufLeave" }, {
				buffer = args.buf,
				callback = function()
					for _, k in ipairs(keymaps) do
						vim.keymap.del(k.mode, k.lhs, { buffer = args.buf })
					end

					return true
				end,
			})
		end,
	})
end

return M
