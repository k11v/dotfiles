return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        json = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        toml = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        yaml = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
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
        "toml",
        "yaml",
      },
    },
  },
}
