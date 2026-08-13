{den, ...}: {
  den.aspects.open-webui = {
    nixos = {
      config,
      pkgs,
      ...
    }: let
      host = "ai.joonaskajava.com";
    in {
      includes = [
        den.aspects.caddy
      ];

      services = {
        open-webui = {
          enable = true;
          package = pkgs.stable.open-webui;
          port = 33537;
        };
      };
      services.caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://localhost:${toString config.services.open-webui.port}
            import cloudflare
          '';
        };
      };
    };
  };
}
