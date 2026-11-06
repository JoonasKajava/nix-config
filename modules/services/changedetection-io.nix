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
          image = "dgtlmoon/changedetection.io:0.70.2@sha256:36ebb3586e9a6b14af6fb488c6e29b60eceb79ee414ecdb6ac2b91dd25b1c7ba";
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
          image = "dgtlmoon/sockpuppetbrowser:0.0.3@sha256:23a7be698216407648b6c78fc55de0411bde550635edc30347373c86a5176fad";
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
