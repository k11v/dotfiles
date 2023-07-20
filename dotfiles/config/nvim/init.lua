-- Init lazy

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.print("Installing lazy")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
  vim.print("Installed lazy")
end
vim.opt.rtp:prepend(lazy_path)

-- Init plugins

require("lazy").setup("plugins")
