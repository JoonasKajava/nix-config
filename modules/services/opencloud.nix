{
  den.aspects.opencloud = let
    host = "opencloud.joonaskajava.com";
  in {
    backup = {config, ...}: {
      patterns = [
        config.services.opencloud.stateDir
      ];
    };
    nixos = {
      config,
      pkgs,
      ...
    }: {
      services.opencloud = {
        enable = true;
        url = "https://${host}";
        package = pkgs.stable.opencloud;
        idpWebPackage = pkgs.stable.opencloud.idp-web;
        webPackage = pkgs.stable.opencloud.web;
        environmentFile = config.sops.templates."opencloud.env".path;
      };

      sops.secrets."opencloud-admin-pass" = {};
      sops.templates."opencloud.env" = {
        inherit (config.services.opencloud) group;
        owner = config.services.opencloud.user;
        restartUnits = ["opencloud.service"];
        content = ''
          PROXY_TLS=false
          IDM_ADMIN_PASSWORD=${config.sops.placeholder."opencloud-admin-pass"}
        '';
      };

      services.caddy = {
        enable = true;
        enableCloudflareIntegration = true;
        virtualHosts = {
          ${host}.extraConfig = ''
            reverse_proxy http://localhost:${toString config.services.opencloud.port}
            import cloudflare
          '';
        };
      };
    };
  };
}
