{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.system.lanzaboote;
in {
  options.${namespace}.system.lanzaboote = {
    enable = mkEnableOption "lanzaboote";
  };

  config = mkIf cfg.enable {
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl/";
      };
    };
  };
}
