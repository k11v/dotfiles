local opts = {
	x_servers = {
		rust_analyzer = {},
	},
}

local plugin = {
	"nvim-lspconfig",
	opts = opts,
}

return { plugin }
