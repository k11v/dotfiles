local M = {}

M.setup = function(opts)
	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("internal.vim_reloading", {}),
		callback = function(args)
			local dirname = vim.fn.stdpath("config")
			local handle = vim.uv.new_fs_event()

			handle:start(
				dirname,
				{ recursive = true },
				vim.schedule_wrap(function(err, filename, _)
					if err then
						vim.notify("failed to watch " .. dirname .. ": " .. err, vim.log.levels.ERROR)

						return
					end

					for k in pairs(package.loaded) do
						if M.package_contains("internal", k) then
							package.loaded[k] = nil
						end
					end

					vim.cmd("source $MYVIMRC")

					vim.api.nvim_exec_autocmds({ "BufLeave" }, { buffer = args.buf, modeline = false })
					vim.api.nvim_exec_autocmds({ "BufEnter" }, { buffer = args.buf, modeline = false })

					vim.notify("reloaded", vim.log.levels.INFO)
				end)
			)

			vim.api.nvim_create_autocmd({ "BufLeave" }, {
				buffer = args.buf,
				callback = function()
					handle:stop()

					return true
				end,
			})
		end,
	})
end

M.package_contains = function(p, subpkg)
	if string.sub(subpkg, 1, #p) == p then
		local n = string.sub(subpkg, #p + 1, #p + 1)
		if n == "." or n == "" then
			return true
		end
	end
	return false
end

return M
