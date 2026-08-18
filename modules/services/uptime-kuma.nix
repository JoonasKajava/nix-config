{
  den.aspects.uptime-kuma = {
    backup.patterns = {config,...}: [
      "+ ${config.services.uptime-kuma.settings.DATA_DIR}"
    ];
    nixos =
      { config, ... }:
      let
        host = "uptime.joonaskajava.com";
      in
      {
        services.caddy = {
          enable = true;
          enableCloudflareIntegration = true;
          virtualHosts = {
            ${host}.extraConfig = ''
              reverse_proxy http://127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}
              import cloudflare
            '';
          };
        };

        services.uptime-kuma = {
          enable = true;
          settings = {
            UPTIME_KUMA_DB_TYPE = "sqlite";
          };
        };
      };
  };
}
