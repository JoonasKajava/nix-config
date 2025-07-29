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
  port = 5380;
in {
  options.${namespace}.services.technitium-dns-server = {
    enable = mkEnableOption "Whether to enable technitium dns server service";
    address = mkOption {
      type = types.str;
      default = "dns.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      stateDir
    ];

    services.caddy.virtualHosts."${cfg.address}" = {
      extraConfig = ''
        reverse_proxy localhost:${toString port}
        import cloudflare
      '';
    };
    systemd.services.technitium-dns-server.serviceConfig = {
      WorkingDirectory = lib.mkForce null;
      BindPaths = lib.mkForce null;
    };

    services.technitium-dns-server = {
      enable = true;
      package = pkgs.stable.technitium-dns-server;
    };
  };
}
