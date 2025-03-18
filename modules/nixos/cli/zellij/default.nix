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
        settings = {
          default_mode = "locked";
        };
      };
    };
  };
}
