return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        go = {
          function()
            vim.opt_local.colorcolumn = "100"
            vim.opt_local.expandtab = false
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
        "go",
        "gomod",
        "gowork",
        "gosum",
      },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "delve",
        "gofumpt",
        "goimports",
        "gopls",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      ensure_configured = {
        gopls = {},
      },
    },
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "goimports" },
      },
    },
  },
}
