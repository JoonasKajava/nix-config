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
    users.users.${config.${namespace}.user.name} = {
      extraGroups = ["scanner" "lp"];
    };

    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };
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
