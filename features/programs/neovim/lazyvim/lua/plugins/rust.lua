return {
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      local crates = require("crates")
      crates.setup({
        popup = { autofocus = true },
        null_ls = {
          enabled = true,
        },
      })

      vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, {
        desc = "Show Versions",
      })

      vim.keymap.set("n", "<leader>cf", crates.show_features_popup, {
        desc = "Show Features",
      })
    end,
  },
}
