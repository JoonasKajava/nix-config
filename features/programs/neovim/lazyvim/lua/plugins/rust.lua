return {
  {
    "mrcjkb/rustaceanvim",
    lazy = false,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
        },
      })
    end,
  },
}
