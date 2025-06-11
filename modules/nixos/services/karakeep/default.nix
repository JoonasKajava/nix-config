{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.${namespace}.services.karakeep;
in {
  options.${namespace}.services.karakeep = {
    enable = mkEnableOption "Whether to enable karakeep service";
    port = mkOption {
      type = types.number;
      default = 38446;
    };
    address = mkOption {
      type = types.str;
      default = "karakeep.joonaskajava.com";
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = {
        ${cfg.address}.extraConfig = ''
          reverse_proxy http://localhost:${toString cfg.port}
        '';
      };
    };

    services.karakeep = {
      enable = true;
      extraEnvironment = {
        PORT = "${toString cfg.port}";
        DISABLE_SIGNUPS = "true";
      };
    };
  };
}
