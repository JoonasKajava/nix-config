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
                image = "bellamy/wallos:5.10.4@sha256:78b73a32ae24bcca67d6f4b96ca76fe29ee8da5e8df1769df1e612a4e776c904";
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
