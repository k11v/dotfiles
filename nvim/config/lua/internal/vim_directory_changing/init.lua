local M = {}

M.setup = function(opts)
	local vim_directory_changing_arms = (opts or {}).vim_directory_changing_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.vim_directory_changing", {}),
		callback = function(args)
			local enabled = false

			for _, arm in ipairs(require("internal.app").matches(args.buf, vim_directory_changing_arms)) do
				enabled = arm.value
			end

			if enabled then
				local src_dir = vim.fn.getcwd()
				local dst_dir = "/"

				local name = vim.api.nvim_buf_get_name(0) -- current buffer
				if name ~= "" then
					local project_name = vim.fs.root(name, ".git")
					if project_name ~= nil and project_name ~= "" then
						dst_dir = project_name
					end
				end

				vim.cmd.cd(dst_dir) -- current buffer

				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					buffer = args.buf,
					callback = function()
						vim.cmd.cd(src_dir) -- current buffer

						return true
					end,
				})
			end
		end,
	})
end

return M
