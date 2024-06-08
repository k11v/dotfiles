return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        json = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.tabstop = 4
          end,
        },
      },
    },
  },
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "json",
      },
    },
  },
}
