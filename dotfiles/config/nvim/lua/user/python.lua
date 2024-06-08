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
      },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
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
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, buffer)
            -- FIXME: Code duplication.
            require("nvchad.configs.lspconfig").on_attach(client, buffer)
            vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = buffer, silent = true })

            -- Disable hover in favor of BasedPyright.
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        python = {
          "ruff_fix",
          "ruff_format",
        },
      },
    },
  },
}
