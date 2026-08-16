{
  den.aspects.wakapi-server = {
    nixos = {...}: let
      host = "wakapi.joonaskajava.com";
      port = 64624;
    in {
      backup.includes = [
        "+ /var/lib/wakapi"
      ];
      services = {
        caddy = {
          enable = true;
          enableCloudflareIntegration = true;
          virtualHosts = {
            ${host}.extraConfig = ''
              reverse_proxy http://127.0.0.1:${toString port}
              import cloudflare
            '';
          };
        };

        wakapi = {
          enable = true;
          settings = {
            server = {
              inherit port;
              public_url = "https://${host}";
            };
            security = {
              allow_signup = false;
              signup_captcha = true;
            };
          };
        };
      };
    };
  };
}
