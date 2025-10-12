-- TODO: When name is set/unset (e.g. with ":write" or ":save"), project name does not change.
-- TODO: When marker is added/removed (e.g. now a Git repository), project name does not change.
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local name = vim.api.nvim_buf_get_name(0)
		if name == "" then
			vim.cmd.cd("/")
			return
		end

		local project_name = vim.fs.root(name, ".git")
		if project_name == nil or project_name == "" then
			vim.cmd.cd("/")
			return
		end

		vim.cmd.cd(project_name)
	end,
})
