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
        "vue-language-server", -- For nvim-lspconfig's volar (nvim-lspconfig uses the legacy name of the Vue language server)
        "vtsls", -- For nvim-lspconfig's vtsls
        "tailwindcss-language-server", -- For nvim-lspconfig's tailwindcss
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        ensure_configured = {
          volar = {
            on_attach = function(client, buffer)
              require("nvchad.configs.lspconfig").on_attach(client, buffer)
              vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = buffer, silent = true })
            end,
          },
          -- https://github.com/mason-org/mason-registry/issues/5064#issuecomment-2016431978
          vtsls = {
            filetypes = { "javascript", "typescript", "vue" },
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
            on_attach = function(client, buffer)
              require("nvchad.configs.lspconfig").on_attach(client, buffer)
              vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = buffer, silent = true })
            end,
          },
          tailwindcss = {
            filetypes = { "html", "css", "javascript", "typescript", "vue" }, -- The default includes "markdown" which is undesired.
            on_attach = function(client, buffer)
              require("nvchad.configs.lspconfig").on_attach(client, buffer)
              vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = buffer, silent = true })
            end,
          },
        },
      })
    end,
  },
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        vue = { "prettier" },
      },
    },
  },
}
