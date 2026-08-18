let
  homeFolder = "/var/lib/wallos";
in
{
  den.aspects.wallos = {
    backup.patterns = [
      homeFolder
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
                image = "bellamy/wallos:latest";
                ports = [ "${toString port}:80/tcp" ];
                volumes = [
                  "${homeFolder}/db:/var/www/html/db:rw"
                  "${homeFolder}/logos:/var/www/html/images/uploads/logos:rw"
                ];
                environment = {
                  TZ = "Europe/Berlin";
                };
                autoStart = true;
                extraOptions = [ "--pull=always" ];
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
