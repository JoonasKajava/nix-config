{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals;

  inherit (config.services.caddy)enableCloudflareIntegration;
in {
  options.services.caddy = {
    enableCloudflareIntegration = mkEnableOption "Whether to enable cloudflare integration for Caddy";
  };

  config = {
    services.caddy = {
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-aRMg7R0dBAy+LJeGCMPg6HKppM6NPX2NPwtc0CeSQLg=";
      };
      extraConfig = mkIf enableCloudflareIntegration ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CF_API_TOKEN}
          }
        }
      '';
    };

    sops.templates."caddy-env".content =
      mkIf enableCloudflareIntegration
      ''
        CF_API_TOKEN=${config.sops.placeholder."cloudflare-api"}
      '';

    systemd.services.caddy = mkIf config.services.caddy.enable {
      after = ["sops-nix.service"];
      serviceConfig.EnvironmentFile = [
        config.sops.templates."caddy-env".path
      ];
    };
  };
}
