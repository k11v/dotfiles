local opts = {
	x_servers = {
		volar = {
			filetypes = { "javascript", "json", "typescript", "vue" },
		},
	},
}

local plugin = {
	url = "nvim-lspconfig",
	opts = opts,
}

return { plugin }
