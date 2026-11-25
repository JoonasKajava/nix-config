{
  den.aspects.changedetection-io = let
    dataDir = "/var/lib/changedetection-io";
    port = 33253;
    playwright-port = 33937;
    host = "changedetection.joonaskajava.com";
  in {
    backup.patterns = [
      "+ ${dataDir}"
    ];

    nixos = {
      virtualisation.oci-containers.containers = {
        changedetection-io = {
          image = "dgtlmoon/changedetection.io:0.70.4@sha256:b6aae2572a0bf1a671b1b202365ddcfe16a31fa8a60be89df606705731b55f8b";
          #ports = ["${builtins.toString cfg.port}:5000/tcp"];
          volumes = [
            "${dataDir}:/datastore:rw"
          ];
          autoStart = true;
          extraOptions = [
            "--network=host"
          ];
          environment = {
            PLAYWRIGHT_DRIVER_URL = "ws://127.0.0.1:${toString playwright-port}";
            BASE_URL = "https://${host}";
            PORT = toString port;
          };
        };

        changedetection-io-playwright = {
          image = "dgtlmoon/sockpuppetbrowser:0.0.5@sha256:71fed9b1de8de865a8f30c61e6d8d129de183bf34f8cc545dc7ae499198ec935";
          ports = ["${toString playwright-port}:3000/tcp"];
          autoStart = true;
          environment = {
            SCREEN_WIDTH = "1920";
            SCREEN_HEIGHT = "1024";
            SCREEN_DEPTH = "16";
            MAX_CONCURRENT_CHROME_PROCESSES = "10";
            CHROME_OPTIONS = "--window-size=1280,1024 --headless --disable-gpu";
          };
        };
      };
      services = {
        caddy.virtualHosts."${host}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString port}
            import cloudflare
          '';
        };
      };
    };
  };
}
