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
    group = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin";
      description = "The group for the Jellyfin service";
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings.jellyfinDirs = {
        "/jellyfin-library"."d" = {
          mode = "770";
          inherit (config.services.jellyfin) user;
          inherit (cfg) group;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
    services = {
      jellyfin.enable = true;

      caddy = {
        virtualHosts."${cfg.host}" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8096
            import cloudflare
          '';
        };
      };
    };

  };
}
