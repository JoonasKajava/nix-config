{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.auto-system-rebuild;

in {
  options.${namespace}.services.auto-system-rebuild = {
    enable = mkEnableOption "Whether to enable automatic system rebuilding";
  };

  config =
    mkIf cfg.enable {
    };
}
