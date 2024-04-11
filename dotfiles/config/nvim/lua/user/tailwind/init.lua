local M = {}

M.setup = function() end

M.get_plugins = function(module)
	return { { import = module .. ".plugins" } }
end

return M
