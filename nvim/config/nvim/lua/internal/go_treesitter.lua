local mod = "internal.go_treesitter"
local group = vim.api.nvim_create_augroup(mod, {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "go",
	callback = function(args)
		---@type internal.treesitter.Opt
		local opt = {
			treesitter = "go",
		}
		vim.b[args.buf].opt = vim.tbl_deep_extend("force", vim.b[args.buf].opt, opt)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gomod",
	callback = function(args)
		---@type internal.treesitter.Opt
		local opt = {
			treesitter = "gomod",
		}
		vim.b[args.buf].opt = vim.tbl_deep_extend("force", vim.b[args.buf].opt, opt)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gosum",
	callback = function(args)
		---@type internal.treesitter.Opt
		local opt = {
			treesitter = "gosum",
		}
		vim.b[args.buf].opt = vim.tbl_deep_extend("force", vim.b[args.buf].opt, opt)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gotmpl",
	callback = function(args)
		---@type internal.treesitter.Opt
		local opt = {
			treesitter = "gotmpl",
		}
		vim.b[args.buf].opt = vim.tbl_deep_extend("force", vim.b[args.buf].opt, opt)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "gowork",
	callback = function(args)
		---@type internal.treesitter.Opt
		local opt = {
			treesitter = "gowork",
		}
		vim.b[args.buf].opt = vim.tbl_deep_extend("force", vim.b[args.buf].opt, opt)
	end,
})
