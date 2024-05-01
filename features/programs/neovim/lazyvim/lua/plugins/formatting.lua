return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
        rust = {"rustfmt"}
      },
      formatters = {
        nixfmt = {
          command = "nixfmt",
        },
      },
    },
  },
}
