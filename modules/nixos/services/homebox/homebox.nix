{den, ...}: {
  den.aspects.homebox = {
    nixos = { config, ...}: let
      port = 7745;
      host = "homebox.joonaskajava.com";
    in {
      includes = [
        den.aspects.caddy
        den.aspects.sops
      ];

      services.caddy = {
        enable = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://localhost:${toString port}
          '';
        };
      };

      backup = {
        includes = [
          "+ /var/lib/homebox/"
        ];
      };

      sops.templates."homebox-env".content = ''
        HBOX_MAILER_HOST=${config.sops.placeholder."smtp/host"}
        HBOX_MAILER_PORT=${config.sops.placeholder."smtp/port-starttls"}
        HBOX_MAILER_USERNAME=${config.sops.placeholder."smtp/username"}
        HBOX_MAILER_PASSWORD=${config.sops.placeholder."smtp/app-password"}
        HBOX_MAILER_FROM=homebox@${host}

      '';
      systemd.services.homebox = {
        after = ["sops-nix.service"];
        serviceConfig.EnvironmentFile = [
          config.sops.templates."homebox-env".path
        ];
      };

      services.homebox = {
        enable = true;
        settings = {
          HBOX_WEB_PORT = toString port;
          HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
          HBOX_WEB_MAX_UPLOAD = "100";
        };
      };
    };
  };
}
