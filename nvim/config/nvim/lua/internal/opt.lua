local mod = "internal.opt"

local function opt(name)
	local value = vim.b.opt[name]
	if value ~= nil then
		vim.print("b.opt." .. name .. " == " .. vim.inspect(value))
		return
	end

	value = vim.g.opt[name]
	vim.print("g.opt." .. name .. " == " .. vim.inspect(value))
end

pcall(vim.api.nvim_del_user_command, "Opt")
vim.api.nvim_create_user_command("Opt", function(o)
	opt(o.args)
end, { nargs = 1 })
