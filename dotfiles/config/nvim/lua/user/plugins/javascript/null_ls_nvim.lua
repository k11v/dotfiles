local opts = function(_, opts)
	vim.list_extend(opts.sources, {
		require("null-ls").builtins.formatting.prettierd,
	})
end

local plugin = {
	url = "none-ls.nvim",
	opts = opts,
}

return { plugin }
