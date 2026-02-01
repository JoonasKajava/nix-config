{config, ...}: let
  host = "wakapi.joonaskajava.com";
  port = 64624;
in {
  services = {
    caddy = {
      virtualHosts = {
        "${host}".extraConfig = ''
          reverse_proxy http://127.0.0.1:${builtins.toString port}
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
}
