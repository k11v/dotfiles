local M = {}

M.setup = function(opts)
	local treesitter_arms = (opts or {}).treesitter_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.treesitter_starting", {}),
		callback = function(args)
			local parser = ""

			for _, arm in ipairs(require("internal.app").matches(args.buf, treesitter_arms)) do
				if type(arm.value) == "table" then
					parser = arm.value[1] or ""
				elseif type(arm.value) == "string" then
					parser = arm.value
				elseif type(arm.value) == "boolean" then
					if arm.value then
						parser = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					end
				end
			end

			if parser ~= "" then
				vim.treesitter.start(args.buf, parser)

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.treesitter.stop(args.buf)

						return true
					end,
				})
			end
		end,
	})
end

return M
