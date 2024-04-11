return {
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
