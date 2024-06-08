return {
  {
    "NvChad",
    opts = {
      inits = {
        function()
          vim.opt.colorcolumn = { "80" }
          vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
        end,
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      ensure_configured = {}, -- User-defined
    },
    config = function(_, opts)
      -- https://github.com/NvChad/NvChad/blob/020b8e4428d6d6ed3cf1d6afc899cb2f76aab1a0/lua/nvchad/configs/lspconfig.lua#L64
      -- require("nvchad.configs.lspconfig").defaults()
      dofile(vim.g.base46_cache .. "lsp")

      local on_attach = require("nvchad.configs.lspconfig").on_attach
      local on_init = require("nvchad.configs.lspconfig").on_init
      local capabilities = require("nvchad.configs.lspconfig").capabilities

      for server, server_opts in pairs(opts.ensure_configured) do
        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
          on_attach = function(client, buffer)
            on_attach(client, buffer)
            vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { buffer = buffer, silent = true })
          end,
          on_init = on_init,
          capabilities = vim.deepcopy(capabilities),
        }, server_opts))
      end
    end,
  },
  {
    "conform.nvim",
    event = "BufWritePre",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
