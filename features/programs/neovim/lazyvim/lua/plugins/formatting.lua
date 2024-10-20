return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
        rust = { "rustfmt" },
        bash = { " shfmt" },
        zsh = { " shfmt" },
        sh = { " shfmt" },
      },
      formatters = {
        alejandra = {
          command = "alejandra",
        },
      },
    },
  },
}
