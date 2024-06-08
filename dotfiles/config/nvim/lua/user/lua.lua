return {
  {
    "NvChad",
    opts = {
      inits_by_ft = {
        lua = {
          function()
            vim.opt_local.colorcolumn = "120"
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
        "lua",
      },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      ensure_configured = {
        lua_ls = {
          settings = {
            Lua = {},
          },
          on_init = function(client)
            -- If .luarc.json exists, configure Lua LS using it.
            for _, w in ipairs(client.workspace_folders) do
              if vim.loop.fs_stat(w.name .. "/.luarc.json") then
                return
              end
            end

            -- Otherwise configure Lua LS for the _currently running_ Neovim.
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            })
          end,
        },
      },
    },
  },
}
