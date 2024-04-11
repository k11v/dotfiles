return {
  {
    "NvChad",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_called, {
        function()
          vim.opt.colorcolumn = { "80" }
          vim.keymap.set({ "n", "v" }, ",", '"+', { silent = true })
        end
      })
    end,
  },
}
