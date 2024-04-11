vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  spec = {
    {
      "NvChad/NvChad",
      lazy = false,
      branch = "v2.5",
      import = "nvchad.plugins",
      opts = {
        ensure_called = {},
      },
      config = function(_, opts)
        require("nvchad.options")
        require("nvchad.autocmds")
        require("nvchad.mappings")
        for _, f in ipairs(opts.ensure_called) do
          f()
        end
      end,
    },
    {
      import = "user"
    },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
