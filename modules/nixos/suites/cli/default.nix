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
      tldr
      rm-improved
      just
      nh
    ];
    lumi = {
      cli = {
        #zsh.enable = true;
        #zsh.powerlevel.enable = false;
        starship.enable = true;
        nushell.enable = true;

        comma.enable = true;

        tmux.enable = false;

        git.enable = true;
        lazygit.enable = true;

        devenv.enable = true;

        neovim.nvf.enable = true;

        bat.enable = true;
      };
    };
    lumi-private = {
      scripts = {
        ssh-setup.enable = true;
        setup-env-secrets.enable = true;
      };
      services.sops.enable = true;
    };
  };
}
