local opts = {
	x_servers = {
		volar = {
			filetypes = { "javascript", "json", "typescript", "vue" },
		},
	},
}

local plugin = {
	"nvim-lspconfig",
	opts = opts,
}

return { plugin }
