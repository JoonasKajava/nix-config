{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.wakapi-server;
  port = 64624;
in {
  options.${namespace}.services.wakapi-server = {
    enable = mkEnableOption "Whether to enable wakapi server service";
    host = mkOption {
      type = types.str;
      default = "wakapi.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    registery.importantDirs = [
      "/var/lib/wakapi"
    ];
    services = {
      caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          ${cfg.host}.extraConfig = ''
            reverse_proxy http://127.0.0.1:${toString port}
            import cloudflare
          '';
        };
      };

      wakapi = {
        enable = true;
        passwordSaltFile = config.sops.secrets.wakapi-password-salt.path;
        settings = {
          server = {
            inherit port;
            public_url = "https://${cfg.host}";
          };
          security = {
            allow_signup = false;
            signup_captcha = true;
          };
        };
      };
    };
  };
}
