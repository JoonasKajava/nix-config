{
  den.aspects.anki-sync-server = let
    host = "anki.joonaskajava.com";
  in {
    backup.patterns = [
      "+ /var/lib/anki-sync-server"
    ];

    nixos = {config, ...}: {
      sops.secrets."anki-user-passwords/joonas" = {
        restartUnits = ["anki-sync-server.service"];
      };
      services = {
        anki-sync-server = {
          enable = true;
          users = [
            {
              username = "joonas";
              passwordFile = config.sops.secrets."anki-user-passwords/joonas".path;
            }
          ];
        };

        caddy.virtualHosts."${host}" = {
          extraConfig = ''
            reverse_proxy http://[::1]:${toString config.services.anki-sync-server.port}
            import cloudflare
          '';
        };
      };
    };
  };
}
