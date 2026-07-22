{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfg = config.${namespace}.services.open-webui;
in {
  options.${namespace}.services.open-webui = {
    enable = mkEnableOption "Whether to enable open-webui service";
    address = mkOption {
      type = types.str;
      default = "ai.joonaskajava.com";
      example = "localhost";
    };
  };

  config = mkIf cfg.enable {
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
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString config.services.open-webui.port}
          import cloudflare
        '';
      };
    };
  };
}
