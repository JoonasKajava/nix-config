{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.ludusavi;
in {
  options.${namespace}.apps.ludusavi = {
    enable = lib.mkEnableOption "Whether to enable ludusavi";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ludusavi;
      description = "The ludusavi package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
  };
}
