{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.pavucontrol;
in {
  options.${namespace}.apps.pavucontrol = {
    enable = lib.mkEnableOption "Whether to enable pavucontrol";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pavucontrol;
      description = "The pavucontrol package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
