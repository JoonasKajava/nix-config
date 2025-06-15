{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.services.ntfy;
in {
  options.${namespace}.services.ntfy = {
    enable = mkEnableOption "Whether to enable ntfy";
    host = mkOption {
      type = lib.types.str;
      default = "ntfy.joonaskajava.com";
      description = "The ntfy host to use for notifications.";
    };
    internalPort = mkOption {
      type = lib.types.port;
      default = 4369;
      description = "The internal port to use for the ntfy service.";
    };
  };

  config = mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        behind-proxy = true;
        listen-http = "127.0.0.1:${cfg.internalPort}";
        base-url = "https://${cfg.host}";
        auth-file = "/var/lib/ntfy/user.db";
        auth-default-access = "deny-all";
        upstream-base-url = "https://ntfy.sh";
      };
    };

    sops.templates."ntfy-env".content = ''
      NTFY_SMTP_SENDER_ADDR=${config.sops.placeholder."smtp/host"}:${config.sops.placeholder."smtp/port-starttls"}
      NTFY_SMTP_SENDER_USER=${config.sops.placeholder."smtp/username"}
      NTFY_SMTP_SENDER_PASS=${config.sops.placeholder."smtp/app-password"}
      NTFY_SMTP_SENDER_FROM=ntfy@ntfy.sh
    '';

    systemd.services.ntfy-sh.EnvironmentFile = [
      config.sops.templates."ntfy-env".path
    ];

    services.caddy.virtualHosts."ntfy.${cfg.host}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${cfg.internalPort}
      '';
    };
  };
}
