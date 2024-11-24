{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.editors.neovim;
  mkLangOption = lang:
    mkOption {
      type = types.bool;
      default = true;
      description = "${lang} support";
    };
in {
  # TODO: Create better neovim module that allows easily enabling or disabling features

  options.mystuff.editors.neovim = {
    enable = mkEnableOption "Whether to enable neovim with my configuration";
    lang = {
      rust = mkLangOption "rust";
      lua = mkLangOption "lua";
      python = mkLangOption "python";
      typescript = mkLangOption "typescript";
      nix = mkLangOption "nix";
      markdown = mkLangOption "markdown";
      html = mkLangOption "html";
      bash = mkLangOption "bash";
    };
  };

  config = mkIf cfg.enable {
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
            nodejs
          ]
          ++ (lib.optional cfg.lang.rust [
            rust-analyzer
            taplo
          ])
          ++ (lib.optional cfg.lang.lua [
            stylua
            lua-language-server
          ])
          ++ (lib.optional cfg.lang.python [
            # TODO: Add python packages
          ])
          ++ (lib.optional cfg.lang.typescript [
            quick-lint-js
            vtsls
            nodePackages.prettier
            nodePackages.typescript-language-server
          ])
          ++ (lib.optional cfg.lang.nix [
            yaml-language-server
            nil
          ])
          ++ (lib.optional cfg.lang.markdown [
            markdownlint-cli2
            marksman
          ])
          ++ (lib.optional cfg.lang.html [
            vscode-langservers-extracted
          ])
          ++ (lib.optional cfg.lang.bash [
            nodePackages.bash-language-server
            shfmt
          ]);

      # TODO: Move when ready
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
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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
  };
}
