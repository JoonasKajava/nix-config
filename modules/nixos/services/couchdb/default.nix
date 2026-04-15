{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.couchdb;
in {
  options.${namespace}.services.couchdb = {
    enable = mkEnableOption "Whether to enable couchdb service";
    address = mkOption {
      type = types.str;
      default = "couchdb.joonaskajava.com";
      example = "localhost";
    };
    port = mkOption {
      type = types.number;
      default = 38131;
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      config.services.couchdb.databaseDir
    ];

    sops.secrets.couchdb-admin-pass.mode = "0400";

    sops.templates.couchdb_admin = {
      owner = "couchdb";
      group = "couchdb";
      mode = "0400";
      restartUnits = ["couchdb.service"];
      content = ''
        [admins]
        admin = ${config.sops.placeholder.couchdb-admin-pass}
      '';
    };

    services.couchdb = {
      enable = true;
      package = pkgs.stable.couchdb3;
      extraConfig = {
        chttpd = {
          require_valid_user = true;
          enable_cors = true;
          max_http_request_size = 4294967296;
        };

        chttpd_auth.require_valid_user = true;

        httpd = {
          WWW-Authenticate = ''Basic realm="couchdb"'';
          enable_cors = true;
        };

        couchdb.max_document_size = 50000000;

        cors = {
          credentials = true;
          origins = "app://obsidian.md,capacitor://localhost,http://localhost,https://localhost";
        };
      };
      extraConfigFiles = [
        config.sops.templates.couchdb_admin.path
      ];
    };

    services.caddy = {
      enable = true;
      enableCloudflareIntegration = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString config.services.couchdb.port}
          import cloudflare
        '';
      };
    };
  };
}
