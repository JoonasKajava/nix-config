{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.suites.cli;
in {
  options.${namespace}.suites.cli = {
    enable = mkEnableOption "Whether to enable the CLI suite.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      htop-vim
      tldr
      fastfetch
      rm-improved
      eza
    ];
    lumi = {
      cli = {
        zsh.enable = true;
        yazi.enable = true;
        tmux.enable = true;
        git.enable = true;
        lazygit.enable = true;
        neovim.enable = false; # for testing
        neovim.nvf.enable = true; # for testing
      };
    };
    lumi-private.scripts = {
      ssh-setup.enable = true;
      setup-env-secrets.enable = true;
    };
  };
}
