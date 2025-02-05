
{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
	cfg = config.${namespace}.cli.neovim;
in
{

  options.${namespace}.cli.neovim = {
    enable = lib.mkEnableOption "neovim";
  };
      config = lib.mkIf cfg.enable {

      xdg.configFile.nvim = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          "/etc/nixos/modules/nixos/cli/neovim/lazyvim";
      };
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
            fzf
            nodejs
          ]
          ++ ( [
            pkgs.rust-analyzer
            pkgs.taplo
          ])
          ++ ([
            pkgs.stylua
            pkgs.lua-language-server
          ])
          ++ ( [
            # TODO: Add python packages
          ])
          ++ ([
            pkgs.quick-lint-js
            pkgs.vtsls
            pkgs.nodePackages.prettier
            pkgs.nodePackages.typescript-language-server
          ])
          ++ ( [
            pkgs.yaml-language-server
            pkgs.nil
          ])
          ++ ( [
            pkgs.markdownlint-cli2
            pkgs.marksman
          ])
          ++ ( [
            pkgs.vscode-langservers-extracted
            pkgs.tailwindcss-language-server
          ])
          ++ ( [
            pkgs.nodePackages.bash-language-server
            pkgs.shfmt
          ]);
      };
      };

}
