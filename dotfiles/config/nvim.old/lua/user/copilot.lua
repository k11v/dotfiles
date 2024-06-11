-- if true then
--   -- Disable Copilot.
--   return {}
-- end

return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = false,
      },
    },
    config = function(_, opts)
      vim.g.copilot_proxy = "http://127.0.0.1:1081"

      -- Manually perform `require("copilot").setup()` to activate the panel
      -- and suggestions modules only when the Copilot client is attached
      -- (which means the Copilot server has been started and configured). This
      -- is necessary for the plugin to respect the proxy setting from the very
      -- beginning.
      --
      -- See:
      --
      -- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/init.lua
      -- - https://github.com/zbirenbaum/copilot.lua/blob/master/lua/copilot/command.lua
      require("copilot.config").setup(opts)
      require("copilot.highlight").setup()

      vim.api.nvim_create_autocmd({ "LspAttach" }, {
        group = vim.api.nvim_create_augroup("user_copilot_lua_proxy", {}),
        once = true,
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "copilot" then
            require("copilot.panel").setup()
            require("copilot.suggestion").setup()
            require("copilot").setup_done = true
          end
        end,
      })

      require("copilot.client").setup()
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "nvim-cmp",
    dependencies = { "copilot-cmp" },
    opts = {
      -- The base has been taken from https://github.com/NvChad/NvChad/blob/156eeef8ecae812acd79d5eb58070d734a6202c6/lua/nvchad/configs/cmp.lua#L104
      sources = {
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
    },
  },
}
