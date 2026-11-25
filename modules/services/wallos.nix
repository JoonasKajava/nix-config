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
                image = "bellamy/wallos:5.11.3@sha256:84c3b218e144a1292b2be6ad2f0b9d620277e860d307c3cfa5aff3ee629aae17";
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
