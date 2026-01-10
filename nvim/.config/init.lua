vim.g.config = {}

vim.api.nvim_create_augroup("FileType", {
	callback = function(args)
		vim.print(args)
	end,
})
