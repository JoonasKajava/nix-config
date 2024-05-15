return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
        rust = { "rustfmt" },
      },
      formatters = {
        alejandra = {
          command = "alejandra",
        },
      },
    },
  },
}
