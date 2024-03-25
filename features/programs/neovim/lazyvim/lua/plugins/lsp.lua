return {
  {
    {
      'VonHeikemen/lsp-zero.nvim',
      config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.on_attach(function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr })
        end)
      end
    },
    {
      'neovim/nvim-lspconfig',
      config = function()
        local lsp_conf = require('lspconfig')

        lsp_conf.nil_ls.setup({})


        lsp_conf.rust_analyzer.setup{}
      end
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
  }
}
