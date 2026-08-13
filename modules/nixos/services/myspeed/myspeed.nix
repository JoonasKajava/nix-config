{den, ...}: {
  den.aspects.myspeed = {
    nixos = {config, ...}: let
      homeFolder = "/var/lib/myspeed";
      host = "myspeed.joonaskajava.com";
      port = 42371;
    in {
      includes = [
        den.aspects.caddy
      ];

      backup.includes = [
        "+ ${homeFolder}"
      ];

      systemd.tmpfiles.rules = [
        "d ${homeFolder} 0750 root root -"
        "z ${homeFolder} 0750 root root -"
      ];

      virtualisation = {
        oci-containers = {
          containers = {
            myspeed = {
              image = "germannewsmaker/myspeed:latest";
              ports = ["${toString port}:5216/tcp"];
              volumes = [
                "${homeFolder}:/myspeed/data:rw"
              ];
              autoStart = true;
              extraOptions = ["--pull=always"];
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
