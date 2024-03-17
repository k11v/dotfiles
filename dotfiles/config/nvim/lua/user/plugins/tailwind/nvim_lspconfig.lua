local opts = {
	x_servers = {
		tailwindcss = {
			filetypes = { "css", "html", "javascript", "typescript", "vue" },
		},
	},
}

local plugin = {
	url = "nvim-lspconfig",
	opts = opts,
}

return { plugin }
