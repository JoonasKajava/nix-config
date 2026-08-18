{den, ...}: {
  den.aspects.open-webui = {
    includes = [
      den.aspects.caddy
    ];
    nixos = {
      config,
      pkgs,
      ...
    }: let
      host = "ai.joonaskajava.com";
    in {
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
