{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.discord;
in {
  options.${namespace}.apps.discord = {
    enable = mkEnableOption "Whether to install Discord";
  };

  config = mkIf cfg.enable {
    programs.discord = {
      enable = true;
    };
  };
}
