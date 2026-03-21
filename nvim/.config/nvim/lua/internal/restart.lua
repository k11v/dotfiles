local mod = "restart"

local function restart(expr)
	vim.cmd([[source $MYVIMRC]])
end

pcall(vim.api.nvim_del_user_command, "Restart")
vim.api.nvim_create_user_command("Restart", function(o)
	restart(o.args)
end, {})
