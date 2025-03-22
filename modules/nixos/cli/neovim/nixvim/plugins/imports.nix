{
  imports = [
    # Ui
    ./ui/dashboard.nix
    ./ui/bufferline.nix
    ./ui/flash.nix
    ./ui/general.nix
    ./ui/indent-blankline.nix
    ./ui/lualine.nix
    ./ui/noice.nix
    ./ui/notify.nix
    ./ui/nui.nix
    ./ui/precognition.nix
    ./ui/toggleterm.nix
    ./ui/ufo.nix

    # Utils
    ./utils/colorizer.nix
    ./utils/debugprint.nix
    ./utils/kulala.nix
    ./utils/mini.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-surround.nix
    ./utils/persistence.nix
    ./utils/plenary.nix
    ./utils/project-nvim.nix
    ./utils/snacks.nix

    # Treesitter
    ./treesitter/treesitter-textobjects.nix
    ./treesitter/treesitter.nix

    ./telescope/telescope.nix

    ./luasnip/luasnip.nix

    # Lsp
    ./lsp/conform.nix
    ./lsp/fidget.nix
    ./lsp/lsp.nix
    ./lsp/lspsaga.nix
    ./lsp/trouble.nix

    # Lang
    ./lang/cpp.nix
    ./lang/css.nix
    ./lang/docker.nix
    ./lang/html.nix
    ./lang/json.nix
    ./lang/lua.nix
    ./lang/markdown.nix
    ./lang/nix.nix
    ./lang/python.nix
    ./lang/shell.nix
    ./lang/typescript.nix
    ./lang/yaml.nix
    # TODO: add vimtex
    # TODO: add rust

    ./git/gitsigns.nix
    # TODO: add lazygit

    ./editor/undotree.nix
    ./editor/whichkey.nix
    # TODO: add oil.nvim

    ./debug/dap.nix

    ./completion/blink.nix
    ./completion/cmp.nix
    ./completion/lspkind.nix

    ./ai/copilot.nix

    #./theme/catppuccin.nix
    ./theme/tokyonight.nix
  ];
}
