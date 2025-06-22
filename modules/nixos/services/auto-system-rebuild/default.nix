{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.auto-system-rebuild;
in {
  options.${namespace}.services.auto-system-rebuild = {
    enable = mkEnableOption "Whether to enable automatic system rebuilding";
  };

  config = mkIf cfg.enable {
    ${namespace}.services.systemd-notifications.enable = true;
    system.autoUpgrade = {
      enable = true;
      flake = "github:JoonasKajava/nix-config";
      allowReboot = true;
    };
  };
}
