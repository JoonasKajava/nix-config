if true then
  return {}
end
return {
  {
    {
      "VonHeikemen/lsp-zero.nvim",
      config = function() end,
      lazy = true,
    },
    {
      "neovim/nvim-lspconfig",
      cmd = { "LspInfo", "LspInstall", "LspStart" },
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local lsp_conf = require("lspconfig")
        local lsp_zero = require("lsp-zero")
        lsp_zero.extend_lspconfig()

        lsp_zero.on_attach(function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })

          vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", {
            desc = "Code Actions",
          })
          vim.keymap.set("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", {
            desc = "Rename",
          })
        end)
        local lsp_capabilities = lsp_zero.get_capabilities()

        local lua_opts = lsp_zero.nvim_lua_ls()

        lsp_conf.lua_ls.setup(lua_opts)

        lsp_conf.nixd.setup({
          cmd = { "nixd" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/etc/nixos/").nixosConfigurations.nixos-desktop.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/etc/nixos/").homeConfigurations.nixos-desktop.options',
                },
              },
            },
          },
        })

        lsp_conf.texlab.setup({})

        lsp_conf.pyright.setup({})

        lsp_conf.quick_lint_js.setup({})

        lsp_conf.bashls.setup({})

        lsp_conf.yamlls.setup({})
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
