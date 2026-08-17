{den, ...}: {
  den.aspects.ntfy = {
    includes = [
      den.aspects.caddy
      den.aspects.sops
    ];
    nixos = {config, ...}: let
      host = "ntfy.joonaskajava.com";
      port = 58685;
    in {
      backup.patterns = [
        "- /var/lib/ntfy-sh/cache"
      ];

      services.ntfy-sh = {
        enable = true;
        settings = {
          behind-proxy = true;
          listen-http = "127.0.0.1:${toString port}";
          base-url = "https://${host}";
          auth-file = "/var/lib/ntfy-sh/user.db";
          auth-default-access = "deny-all";
          upstream-base-url = "https://ntfy.sh";

          attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
          cache-file = "/var/lib/ntfy-sh/cache-file.db";
        };
      };

      sops.templates."ntfy-env".content = ''
        NTFY_SMTP_SENDER_ADDR=${config.sops.placeholder."smtp/host"}:${config.sops.placeholder."smtp/port-starttls"}
        NTFY_SMTP_SENDER_USER=${config.sops.placeholder."smtp/username"}
        NTFY_SMTP_SENDER_PASS=${config.sops.placeholder."smtp/app-password"}
        NTFY_SMTP_SENDER_FROM=ntfy@ntfy.sh
      '';
      systemd.services.ntfy-sh = {
        after = ["sops-nix.service"];
        # serviceConfig.ReadWritePaths = [
        #   "/var/cache/ntfy-sh"
        #   "/var/lib/ntfy-sh"
        # ];
        serviceConfig.EnvironmentFile = [
          config.sops.templates."ntfy-env".path
        ];
      };
      services.caddy = {
        enableCloudflareIntegration = true;
        virtualHosts."${host}" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:${toString port}
            import cloudflare
          '';
        };
      };
    };
  };
}
