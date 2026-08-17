{...}: {
  den.aspects.firefly-iii = let
    host = "firefly.joonaskajava.com";
  in {
    backup.patterns = {config,...}: [
      config.services.firefly-iii.dataDir
    ];
    nixos = {pkgs,config,...}: {
      sops.secrets.firefly-iii-app-key = {
        owner = "firefly-iii";
      };

      services.firefly-iii = {
        enable = true;
        package = pkgs.stable.firefly-iii;
        group = "caddy";
        settings = {
          APP_URL = "https://${host}";
          APP_KEY_FILE = config.sops.secrets.firefly-iii-app-key.path;
        };
      };

      services = {
        caddy.virtualHosts."${host}" = {
          extraConfig = ''
            encode gzip
            file_server
            root * ${config.services.firefly-iii.package}/public
            php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket}
            import cloudflare
          '';
        };
      };
    };
  };
}
