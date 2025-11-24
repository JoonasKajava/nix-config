{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.karakeep;
in {
  options.${namespace}.services.karakeep = {
    enable = mkEnableOption "Whether to enable karakeep service";
    port = mkOption {
      type = types.number;
      default = 38446;
    };
    address = mkOption {
      type = types.str;
      default = "karakeep.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    registery = {
      importantDirs = [
        "/var/lib/karakeep/"
      ];
    };
    systemd.services.karakeep-web.serviceConfig.CacheDirectory = "karakeep";
    services = {
      caddy = {
        enable = true;
        virtualHosts = {
          ${cfg.address}.extraConfig = ''
            reverse_proxy http://localhost:${toString cfg.port}
            import cloudflare
          '';
        };
      };

      karakeep = {
        enable = true;
        package = pkgs.karakeep.overrideAttrs (old: {
          # from https://github.com/NixOS/nixpkgs/pull/416531
          postInstall = ''
            # provide a environment variable to override the cache directory
            # https://github.com/vercel/next.js/discussions/58864
            # solution copied from nextjs-ollama-llm-ui
            substituteInPlace $out/lib/karakeep/apps/web/.next/standalone/node_modules/next/dist/server/image-optimizer.js \
              --replace '_path.join)(distDir,' '_path.join)(process.env["NEXT_CACHE_DIR"] || distDir,'
          '';
        });
        extraEnvironment = rec {
          PORT = "${toString cfg.port}";
          DISABLE_SIGNUPS = "true";
          CRAWLER_FULL_PAGE_SCREENSHOT = "true";
          CRAWLER_FULL_PAGE_ARCHIVE = "true";
          MAX_ASSET_SIZE_MB = "1000";
          CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = MAX_ASSET_SIZE_MB;
          CRAWLER_VIDEO_DOWNLOAD = "true";
          NEXT_CACHE_DIR = "%C/karakeep";
        };
      };
    };
  };
}
