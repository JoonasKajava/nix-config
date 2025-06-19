{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.naps2;
in {
  options.${namespace}.apps.naps2 = {
    enable = lib.mkEnableOption "Whether to enable naps2";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.naps2;
      description = "The naps2 package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
