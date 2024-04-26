return {
  {
    {
      "VonHeikemen/lsp-zero.nvim",
      config = false,
      lazy = true,
      init = function()
        vim.g.lsp_zero_extend_lspconfig = 0
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lsp_conf = require("lspconfig")
        local lsp_zero = require("lsp-zero")
        lsp_zero.extend_lspconfig()

        lsp_zero.on_attach(function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr })
        end)

        local lua_opts = lsp_zero.nvim_lua_ls()

        lsp_conf.lua_ls.setup(lua_opts)

        lsp_conf.nil_ls.setup({})

        lsp_conf.rust_analyzer.setup({})
      end,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
  },
}
