{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.homebox;
in {
  options.${namespace}.services.homebox = {
    enable = mkEnableOption "Whether to enable homebox service";
    internalPort = mkOption {
      type = types.number;
      default = 7745;
    };
    address = mkOption {
      type = types.str;
      default = "homebox.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.internalPort}
        '';
      };
    };

    registery = {
      importantDirs = [
        "/var/lib/homebox/"
      ];
    };

    sops.templates."homebox-env".content = ''
      HBOX_MAILER_HOST=${config.sops.placeholder."smtp/host"}
      HBOX_MAILER_PORT=${config.sops.placeholder."smtp/port-starttls"}
      HBOX_MAILER_USERNAME=${config.sops.placeholder."smtp/username"}
      HBOX_MAILER_PASSWORD=${config.sops.placeholder."smtp/app-password"}
      HBOX_MAILER_FROM=homebox@${cfg.address}

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
        HBOX_WEB_PORT = toString cfg.internalPort;
        HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
        HBOX_WEB_MAX_UPLOAD = "100";
      };
    };
  };
}
