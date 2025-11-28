local M = {}

M.data = {}

M.data.teardowns = {}

M.setup = function(opts)
	local teardowns = M.data.teardowns
	M.data.teardowns = {}

	for _, teardown in ipairs(teardowns) do
		teardown()
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("internal.vim_buf_enter_pre", {}),
		callback = function(args)
			vim.api.nvim_exec_autocmds({ "User" }, { pattern = "BufEnterPre " .. args.buf, modeline = false })
		end,
	})
end

-- arm.pattern
-- arm.pattern.ft - buffer's filetype is
-- arm.pattern.fp - buffer's filepath starts with
-- arm.pattern.root - buffer's filepath is inside a directory whose name is
-- arm.pattern.x - environment contains program whose name is
-- arm.key
-- arm.value
M.matches = function(bufnr, arms)
	local matched_arms = {}
	local matched_from_key = {}

	for _, arm in ipairs(arms) do
		local key
		if type(arm.key) == "string" then
			key = arm.key
		elseif type(arm.key) == "table" then
			key = vim.json.encode(arm.key) -- TODO: Optimize table key.
		else
			key = ""
		end

		if not matched_from_key[key] then
			local ft_matched = false
			local ft = arm.pattern.ft or {}
			if #ft > 0 then
				if vim.list_contains(ft, vim.bo[bufnr].filetype) then
					ft_matched = true
				end
			else
				ft_matched = true
			end

			local root_matched = false
			local root = arm.pattern.root or {}
			if #root > 0 then
				local name = vim.api.nvim_buf_get_name(bufnr)
				if name ~= "" then
					local root_name = vim.fs.root(name, root)
					if root_name ~= nil and root_name ~= "" then
						root_matched = true
					end
				end
			else
				root_matched = true
			end

			local matched = ft_matched and root_matched
			if matched then
				table.insert(matched_arms, arm)

				matched_from_key[key] = true
			end
		end
	end

	return matched_arms
end

return M
