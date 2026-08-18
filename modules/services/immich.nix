{ den, ... }: {
  den.aspects.immich =
    let
      host = "immich.joonaskajava.com";
    in
    {
      includes = [
        den.aspects.caddy
        den.aspects.sops
      ];

      backup.patterns = [
        "+ /var/lib/immich/"
      ];
      nixos =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          inherit (lib.generators) toJSON;
        in
        {
          users.users.immich = {
            extraGroups = [
              "video"
              "render"
            ];
            home = "/var/lib/immich";
            createHome = true;
          };

          services = {
            postgresql.package = pkgs.postgresql_17;

            immich = {
              enable = true;
              # According to immich source file, this is already like this
              # This was here to fix thumbnail creation of raw images.
              # package = pkgs.immich.override {
              #   vips_8_17 = pkgs.vips_8_17.overrideAttrs (prev: {
              #     mesonFlags = prev.mesonFlags ++ ["-Dtiff=disabled"];
              #   });
              # };
              accelerationDevices = null;
              #database.enableVectors = true;
              # I just sops templates to create config file
              settings = null;
              environment = {
                TZ = "Europe/Helsinki";
                IMMICH_CONFIG_FILE = config.sops.templates."immich-config.json".path;
              };
            };
            caddy.virtualHosts."${host}" = {
              extraConfig = ''
                reverse_proxy localhost:${toString config.services.immich.port}
                import cloudflare
              '';
            };
          };
          sops.templates."immich-config.json" = {
            inherit (config.services.immich) group;
            owner = config.services.immich.user;

            content = toJSON { } {
              newVersionCheck.enabled = false;
              server.externalDomain = "https://${host}";
              image.extractEmbedded = true;
              notifications.smtp = {
                enabled = true;
                from = "immich@${host}";
                transport = {
                  ignoreCert = false;
                  host = config.sops.placeholder."smtp/host";
                  port = 587;
                  username = config.sops.placeholder."smtp/username";
                  password = config.sops.placeholder."smtp/app-password";
                };
              };
            };
          };

          systemd.services.immich = {
            after = [ "sops-nix.service" ];
          };
        };
    };
}
