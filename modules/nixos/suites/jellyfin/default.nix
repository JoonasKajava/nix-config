{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.suites.jellyfin;
in {
  options.${namespace}.suites.jellyfin = {
    enable = mkEnableOption "Whether to enable jellyfin suite.";
    host = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.joonaskajava.com";
      description = "The host name for the Jellyfin service";
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings.jellyfinDirs = {
        "/jellyfin-library"."d" = {
          mode = "700";
          inherit (config.services.jellyfin) user group;
        };
      };
    };

    services.jellyfin.enable = true;
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    ${namespace}.services.caddy.enable = true;
    services.caddy = {
      virtualHosts."${cfg.host}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
          import cloudflare
        '';
      };
    };
  };
}
