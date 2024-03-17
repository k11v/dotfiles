local opts = {
	x_servers = {
		tailwindcss = {
			filetypes = { "css", "html", "javascript", "typescript", "vue" },
		},
	},
}

local plugin = {
	"nvim-lspconfig",
	opts = opts,
}

return { plugin }
