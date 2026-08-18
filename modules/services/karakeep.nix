{den, ...}: {
  den.aspects.karakeep = {
    includes = [
      den.aspects.caddy
    ];
    backup = {
      patterns = [
        "+ /var/lib/karakeep/"
      ];
    };
    nixos = {pkgs, ...}: let
      host = "karakeep.joonaskajava.com";
      port = 38446;
    in {
      systemd.services.karakeep-web.serviceConfig.CacheDirectory = "karakeep";
      services = {
        caddy = {
          enable = true;
          virtualHosts = {
            ${host}.extraConfig = ''
              reverse_proxy http://localhost:${toString port}
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
            PORT = "${toString port}";
            DISABLE_SIGNUPS = "true";
            CRAWLER_FULL_PAGE_SCREENSHOT = "true";
            CRAWLER_FULL_PAGE_ARCHIVE = "true";
            CRAWLER_SCREENSHOT_TIMEOUT_SEC = "30";
            MAX_ASSET_SIZE_MB = "1000";
            CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = MAX_ASSET_SIZE_MB;
            CRAWLER_VIDEO_DOWNLOAD = "true";
            NEXT_CACHE_DIR = "%C/karakeep";
            NEXTAUTH_URL = "https://${host}";
          };
        };
      };
    };
  };
}
