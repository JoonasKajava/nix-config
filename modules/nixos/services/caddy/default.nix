{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.generators) toJSON;

  cfg = config.${namespace}.services.caddy;
in {
  options.${namespace}.services.caddy = {
    enable = mkEnableOption "Whether to enable caddy";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-2D7dnG50CwtCho+U+iHmSj2w14zllQXPjmTHr6lJZ/A=";
      };
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CF_API_TOKEN}
          }
        }
      '';
    };

    sops.templates."caddy-env".content = ''
      CF_API_TOKEN=${config.sops.placeholder."cloudflare-api"}
    '';

    systemd.services.caddy = {
      after = ["sops-nix.service"];
      serviceConfig.EnvironmentFile = [
        config.sops.templates."caddy-env".path
      ];
    };
  };
}
