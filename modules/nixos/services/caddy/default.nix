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
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = optionals enableCloudflareIntegration ["github.com/caddy-dns/cloudflare@v0.2.1"];
        hash = "sha256-2D7dnG50CwtCho+U+iHmSj2w14zllQXPjmTHr6lJZ/A=";
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

    systemd.services.caddy = {
      after = ["sops-nix.service"];
      serviceConfig.EnvironmentFile = [
        config.sops.templates."caddy-env".path
      ];
    };
  };
}
