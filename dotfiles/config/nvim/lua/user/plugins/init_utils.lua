local M = {}

-- https://github.com/LazyVim/LazyVim/blob/864c58cae6df28c602ecb4c94bc12a46206760aa/lua/lazyvim/util/plugin.lua#L60
M.create_lazy_file_event = function()
	lazy_event = require("lazy.core.handler.event")

	lazy_event.mappings["LazyFile"] = {
		id = "LazyFile",
		event = "User",
		pattern = "LazyFile",
	}

	local events = {}
	local done = false
	local function load()
		if #events == 0 or done then
			return
		end
		done = true
		vim.api.nvim_del_augroup_by_name("LazyFile")

		local skips = {}
		for _, event in ipairs(events) do
			skips[event.event] = skips[event.event] or lazy_event.get_augroups(event.event)
		end

		vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
		for _, event in ipairs(events) do
			if vim.api.nvim_buf_is_valid(event.buf) then
				lazy_event.trigger({
					event = event.event,
					exclude = skips[event.event],
					data = event.data,
					buf = event.buf,
				})
				if vim.bo[event.buf].filetype then
					lazy_event.trigger({
						event = "FileType",
						buf = event.buf,
					})
				end
			end
		end
		vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
		events = {}
	end
	load = vim.schedule_wrap(load)

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
		group = vim.api.nvim_create_augroup("LazyFile", {}),
		callback = function(event)
			table.insert(events, event)
			load()
		end,
	})
end

return M
