{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.mealie;
in {
  options.${namespace}.services.mealie = {
    enable = mkEnableOption "Whether to enable mealie";
    host = mkOption {
      type = lib.types.str;
      default = "mealie.joonaskajava.com";
      description = "The host name for the mealie service";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      "/var/lib/mealie/"
    ];

    sops.secrets."openai-api" = {
      restartUnits = ["mealie.service"];
    };

    services.mealie = {
      enable = true;
      settings = {
        BASE_URL = "https://${cfg.host}";
        TZ = "Europe/Helsinki";
        ALLOW_SIGNUP = "false";
        TOKEN_TIME = 87000;
      };
    };

    sops.templates."mealie-env".content = ''
      SMTP_HOST=${config.sops.placeholder."smtp/host"}
      SMTP_PORT=${config.sops.placeholder."smtp/port-starttls"}
      SMTP_USER=${config.sops.placeholder."smtp/username"}
      SMTP_PASSWORD=${config.sops.placeholder."smtp/app-password"}
      SMTP_FROM_NAME=Mealie
      SMTP_FROM_EMAIL=mealie@${cfg.host}
      OPENAI_API_KEY=${config.sops.placeholder."openai-api"}
    '';
    systemd.services.mealie = {
      after = ["sops-nix.service"];
      serviceConfig.EnvironmentFile = [
        config.sops.templates."mealie-env".path
      ];
    };

    services.caddy.virtualHosts."${cfg.host}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.mealie.port}
        import cloudflare
      '';
    };
  };
}
