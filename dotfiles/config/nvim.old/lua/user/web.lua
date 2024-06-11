return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        html = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        css = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        javascript = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        typescript = {
          function()
            vim.opt_local.colorcolumn = "80"
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        },
        vue = {
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
        "html",
        "css",
        "javascript",
        "typescript",
        "vue",
      },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "tailwindcss-language-server",
        "vtsls",
        "vue-language-server",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        ensure_configured = {
          volar = {},
          vtsls = {
            filetypes = { "javascript", "typescript", "vue" },
            -- https://github.com/mason-org/mason-registry/issues/5064#issuecomment-2016431978
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = (
                        require("mason-registry").get_package("vue-language-server"):get_install_path()
                        .. "/node_modules/@vue/language-server"
                      ),
                      languages = { "vue" },
                      configNamespace = "typescript",
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                  },
                },
              },
            },
          },
          tailwindcss = {
            -- The default includes "markdown" which is undesired.
            filetypes = { "html", "css", "javascript", "typescript", "vue" },
          },
        },
      })
    end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        html = {
          "prettier",
        },
        css = {
          "prettier",
        },
        javascript = {
          "prettier",
        },
        typescript = {
          "prettier",
        },
        vue = {
          "prettier",
        },
      },
    },
  },
}
