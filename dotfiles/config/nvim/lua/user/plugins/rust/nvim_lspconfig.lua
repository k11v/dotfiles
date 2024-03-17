local opts = {
	x_servers = {
		rust_analyzer = {},
	},
}

local plugin = {
	url = "nvim-lspconfig",
	opts = opts,
}

return { plugin }
