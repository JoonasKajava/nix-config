{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.printing;
in {
  options.${namespace}.services.printing = {
    enable = mkEnableOption "Whether to enable printing services";
  };

  config = mkIf cfg.enable {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          hplip
        ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
