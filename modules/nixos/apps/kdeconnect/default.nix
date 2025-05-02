{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.kdeconnect;
in {
  options.${namespace}.apps.kdeconnect = {
    enable = mkEnableOption "Whether to install kdeconnect";
  };

  config = mkIf cfg.enable {
    snowfallorg.users.${config.${namespace}.user.name}.home.config = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
    programs.kdeconnect = {
      enable = true;
    };
  };
}
