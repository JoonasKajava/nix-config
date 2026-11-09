let
  homeFolder = "/var/lib/wallos";
in
{
  den.aspects.wallos = {
    backup.patterns = [
      "+ ${homeFolder}"
    ];
    nixos =
      let
        host = "wallos.joonaskajava.com";
        port = 8282;
      in
      {
        virtualisation = {
          oci-containers = {
            containers = {
              wallos = {
                image = "bellamy/wallos:5.11.1@sha256:182d4be4dae26834cc5cec3686bb142e78b0a139a0eb1059355d061d8c0de3e5";
                ports = [ "${toString port}:80/tcp" ];
                volumes = [
                  "${homeFolder}/db:/var/www/html/db:rw"
                  "${homeFolder}/logos:/var/www/html/images/uploads/logos:rw"
                ];
                environment = {
                  TZ = "Europe/Berlin";
                };
                autoStart = true;
              };
            };
          };
        };
        services.caddy = {
          enable = true;
          enableCloudflareIntegration = true;
          virtualHosts = {
            ${host}.extraConfig = ''
              reverse_proxy http://localhost:${toString port}
              import cloudflare
            '';
          };
        };
      };
  };
}
