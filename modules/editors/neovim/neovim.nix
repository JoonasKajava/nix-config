{
  config,
  lib,
  pkgs,
  inputs,
  user,
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
          ++ (lib.optionals cfg.lang.rust [
            pkgs.rust-analyzer
            pkgs.taplo
          ])
          ++ (lib.optionals cfg.lang.lua [
            pkgs.stylua
            pkgs.lua-language-server
          ])
          ++ (lib.optionals cfg.lang.python [
            # TODO: Add python packages
          ])
          ++ (lib.optionals cfg.lang.typescript [
            pkgs.quick-lint-js
            pkgs.vtsls
            pkgs.nodePackages.prettier
            pkgs.nodePackages.typescript-language-server
          ])
          ++ (lib.optionals cfg.lang.nix [
            pkgs.yaml-language-server
            pkgs.nil
          ])
          ++ (lib.optionals cfg.lang.markdown [
            pkgs.markdownlint-cli2
            pkgs.marksman
          ])
          ++ (lib.optionals cfg.lang.html [
            pkgs.vscode-langservers-extracted
            pkgs.tailwindcss-language-server
          ])
          ++ (lib.optionals cfg.lang.bash [
            pkgs.nodePackages.bash-language-server
            pkgs.shfmt
          ]);
      };

      xdg.configFile.nvim = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          "/etc/nixos/modules/editors/neovim/lazyvim";
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

    fonts.packages = with pkgs.nerd-fonts; [
      fira-mono
    ];
  };
}
