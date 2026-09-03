{ den, ... }: {
  den.aspects.paperless =
    let
      host = "paperless.joonaskajava.com";
      gotenbergPort = 43467;
      portAi = 3000;
      hostAi = "paperless-ai.joonaskajava.com";
    in
    {
      includes = [ den.aspects.samba ];

      backup.patterns = [
        "+ /var/lib/paperless/"
        "+ /var/lib/paperless/paperless-ai/"
      ];

      nixos =
        {
          config,
          lib,
          ...
        }:
        {
          virtualisation = {
            oci-containers = {
              containers = {
                paperless-ai = {
                  image = "clusterzx/paperless-ai:latest";
                  ports = [ "${toString portAi}:3000/tcp" ];
                  volumes = [
                    "/var/lib/paperless/paperless-ai:/app/data:rw"
                  ];
                  autoStart = true;
                  extraOptions = [
                    "--pull=always"
                    "--network=host"
                  ];
                };
              };
            };
          };

          # Paperless blocks shutdown way too often, so we set a reasonable timeout
          # systemd.services.paperless-task-queue.serviceConfig.TimeoutSec = 15;

          services = {
            caddy = {
              enable = true;
              enableCloudflareIntegration = true;
              virtualHosts = {
                "${host}".extraConfig = ''
                  reverse_proxy http://127.0.0.1:${toString config.services.paperless.port}
                  import cloudflare
                '';
                "${hostAi}".extraConfig = ''
                  reverse_proxy http://127.0.0.1:${toString portAi}
                  import cloudflare
                '';
              };
            };

            gotenberg = {
              port = gotenbergPort;
            };
            paperless = {
              enable = true;
              # TODO:
              # consumptionDir = config.${namespace}.services.samba.printerPath;

              port = 28981;
              domain = host;
              configureTika = true;
              settings = {
                PAPERLESS_OCR_LANGUAGE = "eng+fin+swe";
                PAPERLESS_TIKA_GOTENBERG_ENDPOINT = lib.mkForce "http://localhost:${toString config.services.gotenberg.port}";
              };
            };
          };
        };
    };
}
