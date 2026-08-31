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
          image = "dgtlmoon/changedetection.io:latest";
          #ports = ["${builtins.toString cfg.port}:5000/tcp"];
          volumes = [
            "${dataDir}:/datastore:rw"
          ];
          autoStart = true;
          extraOptions = [
            "--pull=always"
            "--network=host"
          ];
          environment = {
            PLAYWRIGHT_DRIVER_URL = "ws://127.0.0.1:${toString playwright-port}";
            BASE_URL = "https://${host}";
            PORT = toString port;
          };
        };

        changedetection-io-playwright = {
          image = "dgtlmoon/sockpuppetbrowser:latest";
          ports = ["${toString playwright-port}:3000/tcp"];
          autoStart = true;
          extraOptions = ["--pull=always"];
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
