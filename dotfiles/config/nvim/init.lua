local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	})
end
vim.opt.rtp:prepend(lazy_path)

require("user.options")
require("user.automatics")
require("user.plugins")
require("user.mappings")
