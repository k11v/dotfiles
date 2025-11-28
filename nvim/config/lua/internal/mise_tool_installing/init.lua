local M = {}

M.setup = function(opts)
	-- Uses mise executable.

	-- TODO: Mise tool updating (see `mise latest --installed -- <tool>` and `mise latest -- <tool>`).

	local mise_tool_arms = (opts or {}).mise_tool_arms or {}

	do
		local tools = {}

		for _, arm in ipairs(mise_tool_arms) do
			local name = arm.key
			local version = arm.value

			table.insert(tools, name .. "@" .. version)
		end

		if #tools > 0 then
			if not M.equal_hash("mise-install", tools) then
				vim.notify("installing mise tools", vim.log.levels.INFO)

				local mise_result = M.system_echo_sync(vim.list_extend({ "mise", "install", "--" }, tools), {
					timeout = 10 * 60 * 1000,
				})

				if mise_result.code == 0 then
					M.set_hash("mise-install", tools)
					vim.notify("installed mise tools", vim.log.levels.INFO)
				else
					vim.notify("failed to install mise tools", vim.log.levels.ERROR)
				end
			end
		end
	end
end

M.system_echo_sync = function(cmd, opts)
	local obj = nil
	local echo = {}
	local i = 0

	opts = vim.tbl_deep_extend("force", {}, opts or {}, {
		text = true,
		stdout = function(_, data)
			if data then
				table.insert(echo, { "| " .. data })
			end
		end,
		stderr = function(_, data)
			if data then
				table.insert(echo, { "| " .. data, "ErrorMsg" })
			end
		end,
	})

	local on_exit = function(o)
		obj = o
	end

	vim.system(cmd, opts, on_exit)

	while true do
		local done = obj ~= nil

		local j = #echo
		while i < j do
			i = i + 1
			vim.api.nvim_echo({ echo[i] }, true, {})
		end

		if done then
			break
		end

		vim.wait(10)
	end

	return obj
end

M.get = function(key)
	local value = M.get_string(key)
	if value == nil then
		return nil
	end

	local ok, decoded = pcall(vim.mpack.decode, value)
	if not ok then
		return nil
	end

	return decoded
end

M.set = function(key, value)
	local encoded

	if value ~= nil then
		encoded = vim.mpack.encode(value)
	else
		encoded = nil
	end

	M.set_string(key, encoded)
end

M.equal_hash = function(key, value)
	local got_hash = vim.fn.sha256(vim.mpack.encode(value or ""))
	local want_hash = M.get_string(key) or ""

	return got_hash == want_hash
end

M.set_hash = function(key, value)
	local got_hash = vim.fn.sha256(vim.mpack.encode(value or ""))

	M.set_string(key, got_hash)
end

M.get_string = function(key)
	local cache_dir = vim.fn.stdpath("cache") .. "/internal"
	local cache_file = cache_dir .. "/" .. key .. ".mpack"

	-- If key is empty, return empty string.
	if key == nil or key == "" then
		return nil
	end

	-- Open file.
	local fd = vim.uv.fs_open(cache_file, "r", 438) -- 0666
	if not fd then
		return nil
	end

	-- Read content.
	local stat = vim.uv.fs_fstat(fd)
	local content = vim.uv.fs_read(fd, stat.size, 0)
	vim.uv.fs_close(fd)

	-- Return content.
	if not content then
		return nil
	end

	return content
end

M.set_string = function(key, value)
	local cache_dir = vim.fn.stdpath("cache") .. "/internal"
	local cache_file = cache_dir .. "/" .. key .. ".mpack"

	-- If key is empty, return.
	if key == nil or key == "" then
		return
	end

	-- If value is nil, remove file and return.
	if value == nil then
		vim.uv.fs_unlink(cache_file)
		return
	end

	-- Create directory.
	if vim.fn.isdirectory(cache_dir) == 0 then
		vim.fn.mkdir(cache_dir, "p")
	end

	-- Open file.
	local fd = vim.uv.fs_open(cache_file, "w", 420) -- 0644
	if not fd then
		vim.notify("can't set string", vim.log.levels.ERROR)
		return
	end

	-- Write content.
	vim.uv.fs_write(fd, value, 0)
	vim.uv.fs_close(fd)
end

return M
