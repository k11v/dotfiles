return {
  {
    "NvChad",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_called, {
        function()
          vim.opt.colorcolumn = { "80" }
          vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
        end,
      })
    end,
  },
  {
    "nvim-lspconfig",
    opts = {
      ensure_configured = {}, -- User-defined
    },
    config = function(_, opts)
      require("nvchad.configs.lspconfig").defaults()
      local on_attach = require("nvchad.configs.lspconfig").on_attach
      local on_init = require("nvchad.configs.lspconfig").on_init
      local capabilities = require("nvchad.configs.lspconfig").capabilities

      for server, server_opts in pairs(opts.ensure_configured) do
        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = vim.deepcopy(capabilities),
        }, server_opts))
      end
    end,
  },
  {
    "conform.nvim",
    event = "BufWritePre",
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
