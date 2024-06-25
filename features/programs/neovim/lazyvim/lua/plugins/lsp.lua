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

          vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", {
            desc = "Code Actions",
          })
          vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", {
            desc = "Rename",
          })
        end)

        local lua_opts = lsp_zero.nvim_lua_ls()

        lsp_conf.lua_ls.setup(lua_opts)

        lsp_conf.nil_ls.setup({})

        lsp_conf.tsserver.setup({})

        lsp_conf.texlab.setup({})

        lsp_conf.pyright.setup({})
      end,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    {
      "nvimtools/none-ls.nvim",
      config = function()
        local null_ls = require("null-ls")

        null_ls.setup()
      end,
    },
  },
}
