{den, ...}: {
  den.aspects.homebox = {
    includes = [
      den.aspects.caddy
      den.aspects.sops
    ];
    backup = {
      patterns = [
        "+ /var/lib/homebox/"
      ];
    };
    nixos = {
      config,
      pkgs,
      ...
    }: let
      port = 7745;
      host = "homebox.joonaskajava.com";
    in {
      services.caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString port}
            import cloudflare
          '';
        };
      };

      sops.templates."homebox-env".restartUnits = ["homebox.service"];

      sops.templates."homebox-env".content = ''
        HBOX_MAILER_HOST=${config.sops.placeholder."smtp/host"}
        HBOX_MAILER_PORT=${config.sops.placeholder."smtp/port-starttls"}
        HBOX_MAILER_USERNAME=${config.sops.placeholder."smtp/username"}
        HBOX_MAILER_PASSWORD=${config.sops.placeholder."smtp/app-password"}
        HBOX_MAILER_FROM=homebox@${host}

      '';
      systemd.services.homebox = {
        serviceConfig.EnvironmentFile = [
          config.sops.templates."homebox-env".path
        ];
      };

      services.homebox = {
        enable = true;
        package = pkgs.stable.homebox;
        settings = {
          HBOX_WEB_PORT = toString port;
          HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
          HBOX_WEB_MAX_UPLOAD = "100";
          HBOX_OPTIONS_TRUST_PROXY = "true";
        };
      };
    };
  };
}
