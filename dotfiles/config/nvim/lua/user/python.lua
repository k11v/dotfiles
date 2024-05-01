return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        python = {
          function()
            vim.opt_local.colorcolumn = "88"
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
        "python",
        "toml",
      },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "basedpyright",
        "ruff",
        "ruff-lsp",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      ensure_configured = {
        basedpyright = {},
        ruff_lsp = {
          on_attach = function(client, _)
            require("nvchad.configs.lspconfig").on_attach(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of BasedPyright.
              client.server_capabilities.hoverProvider = false
            end
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
    },
  },
}
