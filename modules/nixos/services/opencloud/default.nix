{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.opencloud;
in {
  options.${namespace}.services.opencloud = {
    enable = mkEnableOption "Whether to enable opencloud service";
    address = mkOption {
      type = types.str;
      default = "opencloud.joonaskajava.com";
      example = "localhost";
    };
    internalPort = mkOption {
      type = types.number;
      default = 42529;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      config.services.opencloud.stateDir
    ];

    services.opencloud = {
      enable = true;
      url = "https://${cfg.address}";
      package = pkgs.stable.opencloud;
      idpWebPackage = pkgs.stable.opencloud.idp-web;
      webPackage = pkgs.stable.opencloud.web;
      environmentFile = config.sops.templates."opencloud.env".path;
    };

    sops.secrets."opencloud-admin-pass" = {};
    sops.templates."opencloud.env" = {
      inherit (config.services.opencloud) group;
      owner = config.services.opencloud.user;
      restartUnits = ["opencloud.service"];
      content = ''
        PROXY_TLS=false
        IDM_ADMIN_PASSWORD=${config.sops.placeholder."opencloud-admin-pass"}
      '';
    };

    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.opencloud.port}
          import cloudflare
        '';
      };
    };
  };
}
