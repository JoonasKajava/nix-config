{
  pkgs,
  lib,
  user,
  ...
}: {
  home-manager.users.${user.username} = {config, ...}: {
    programs.neovim = {
      vimAlias = true;
      enable = true;
      viAlias = true;

      extraPackages = with pkgs;
        [
          gcc
          ripgrep
          cargo
          xclip
          alejandra
          tree-sitter
          fd

          stylua
          lua-language-server
          quick-lint-js
        ]
        # Lsp from Node
        ++ (with pkgs.nodePackages; [
          typescript-language-server
          bash-language-server
          vscode-langservers-extracted
        ]);
    };
    xdg.configFile.nvim = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "/etc/nixos/features/programs/neovim/lazyvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  nix.settings = {
    trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
    substituters = ["https://devenv.cachix.org"];
    trusted-users = ["root" user.username];
  };

  programs.direnv.enable = true;

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      lazygit
      devenv
    ];
  };

  fonts.packages = with pkgs; [nerdfonts];
}
