local M = {}

M.setup = function(opts)
	local old_config = vim.diagnostic.config(nil)

	vim.diagnostic.config({
		underline = { severity = { min = "HINT", max = "ERROR" } }, -- Show all diagnostics as underline
		virtual_text = { severity = { min = "ERROR", max = "ERROR" } }, -- Show more details immediately for errors
		signs = { severity = { min = "WARN", max = "ERROR" }, priority = 200 }, -- Show signs for warnings and errors
	})

	table.insert(require("internal.app").data.teardowns, function()
		vim.diagnostic.config(old_config)
	end)
end

return M
