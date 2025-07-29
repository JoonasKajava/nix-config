{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.technitium-dns-server;
  stateDir = "/var/lib/technitium-dns-server";
in {
  options.${namespace}.services.technitium-dns-server = {
    enable = mkEnableOption "Whether to enable technitium dns server service";
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      stateDir
    ];

    systemd.tmpfiles.settings.technitium-dns-server = {
      "${stateDir}"."d" = {
        mode = "770";
        user = "technitium-dns-server";
        group = "technitium-dns-server";
      };
    };

    services.technitium-dns-server = {
      enable = true;
      package = pkgs.stable.technitium-dns-server;
      openFirewall = true;
    };
  };
}
