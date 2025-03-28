{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.cli.zellij;
in {
  options.${namespace}.cli.zellij = {
    enable = mkEnableOption "Whether to install zellij";
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      programs.zellij = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          default_mode = "locked";
          show_startup_tips = false;
        };
      };
    };
  };
}
