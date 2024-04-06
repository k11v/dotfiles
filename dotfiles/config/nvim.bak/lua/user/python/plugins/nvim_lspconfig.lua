local opts = {
	x_servers = {
		pyright = {},
	},
}

local plugin = {
	"nvim-lspconfig",
	opts = opts,
}

return { plugin }
