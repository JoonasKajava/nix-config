{
  config,
  den,
  ...
}: {
  den.aspects.forgejo = {
    backup.patterns = {config,...}: [
      "+ ${config.services.forgejo.stateDir}"
    ];

    includes = [
      den.aspects.caddy
    ];

    nixos = {pkgs, ...}: let
      host = "forgejo.joonaskajava.com";
      port = 38131;
    in {
      services.forgejo = {
        enable = true;
        package = pkgs.stable.forgejo-lts;
        lfs.enable = true;
        database.type = "sqlite3";
        settings.server = {
          HTTP_PORT = port;
          ROOT_URL = "https://${host}";
        };
        #https://forgejo.org/docs/next/admin/actions/runner-installation/#nixos
      };

      services.caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}
            import cloudflare
          '';
        };
      };
    };
  };
}
