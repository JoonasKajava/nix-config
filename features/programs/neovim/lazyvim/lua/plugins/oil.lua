return {
  {
    "stevearc/oil.nvim",
    config = function()
      local oil_conf = require("oil")
      oil_conf.setup()

      vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
    end,
  },
}
