return {
  {
    "stevearc/oil.nvim",
    config = function()
      local oil_conf = require("oil")
      oil_conf.setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })

      vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
    end,
  },
}
