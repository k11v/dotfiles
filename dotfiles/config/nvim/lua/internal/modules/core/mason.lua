local utils = require("internal.utils")

return {
	url = "https://github.com/williamboman/mason.nvim",
	event = "VeryLazy",
	opts_extend = { "x_packages" },
	opts = {
		x_packages = {
			"efm",
		},
		PATH = "skip",
	},
	init = function()
		vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
	end,
	config = function(_, opts)
		require("mason").setup(opts)

		opts.x_packages = utils.without_duplicates(opts.x_packages)

		local registry = require("mason-registry")
		registry.refresh(function()
			local is_mason_open = false
			for _, name in ipairs(opts.x_packages) do
				local p = registry.get_package(name)
				if not p:is_installed() then
					if not is_mason_open then
						vim.cmd.Mason()
						is_mason_open = true
					end
					p:install()
				end
			end
		end)
	end,
}
