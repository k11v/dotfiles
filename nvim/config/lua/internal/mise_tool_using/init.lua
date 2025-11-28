local M = {}

M.setup = function(opts)
	-- Uses mise executable.

	-- FIXME: If "go" tool's bin is before "golangci-lint" tool's bin in PATH,
	-- "go" tool's bin has "golangci-lint" (e.g. it was installed with "go install"),
	-- then "golangci-lint" from "go" will be used over "golangci-lint" from "golangci-lint".

	local mise_tool_arms = (opts or {}).mise_tool_arms or {}

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		group = vim.api.nvim_create_augroup("internal.mise_tool_using", {}),
		callback = function(args)
			local tools = {}

			for _, arm in ipairs(require("internal.app").matches(args.buf, mise_tool_arms)) do
				local name = arm.key
				local version = arm.value

				table.insert(tools, name .. "@" .. version)
			end

			if #tools > 0 then
				local obj = vim.system(vim.list_extend({ "mise", "bin-paths", "--" }, tools), { text = true })

				local res = obj:wait(1 * 1000)

				if res.code == 0 and #res.stderr == 0 and not string.find(res.stdout, ":") then
					local bin_paths = vim.split(res.stdout, "\n", { trimempty = true })
					local old_path = vim.env.PATH
					local new_path = table.concat(bin_paths, ":") .. ":" .. old_path

					vim.env.PATH = new_path

					vim.api.nvim_create_autocmd({ "BufLeave" }, {
						buffer = args.buf,
						callback = function()
							vim.env.PATH = old_path

							return true
						end,
					})
				else
					vim.notify("failed to use mise tools: " .. res.stderr, vim.log.levels.ERROR)
				end
			end
		end,
	})
end

return M
