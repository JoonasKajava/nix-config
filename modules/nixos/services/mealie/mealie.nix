{den, ...}: {
  den.aspects.mealie = {
    nixos = {config, ...}: let
      host = "mealie.joonaskajava.com";
    in {
      includes = [
        den.aspects.caddy
        den.aspects.sops
      ];

      backup.includes = [
        "+ /var/lib/mealie/"
      ];

      sops.secrets."openai-api" = {
        restartUnits = ["mealie.service"];
      };

      services.mealie = {
        enable = true;
        settings = {
          BASE_URL = "https://${host}";
          TZ = "Europe/Helsinki";
          ALLOW_SIGNUP = "false";
          TOKEN_TIME = 9500;
        };
      };

      sops.templates."mealie-env".content = ''
        SMTP_HOST=${config.sops.placeholder."smtp/host"}
        SMTP_PORT=${config.sops.placeholder."smtp/port-starttls"}
        SMTP_USER=${config.sops.placeholder."smtp/username"}
        SMTP_PASSWORD=${config.sops.placeholder."smtp/app-password"}
        SMTP_FROM_NAME=Mealie
        SMTP_FROM_EMAIL=mealie@${host}
        OPENAI_API_KEY=${config.sops.placeholder."openai-api"}
      '';
      systemd.services.mealie = {
        after = ["sops-nix.service"];
        serviceConfig.EnvironmentFile = [
          config.sops.templates."mealie-env".path
        ];
      };

      services.caddy.virtualHosts."${host}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.mealie.port}
          import cloudflare
        '';
      };
    };
  };
}
