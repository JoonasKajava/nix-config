{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.hardware.keyboards.bazecor;
in {
  options.${namespace}.hardware.keyboards.bazecor = {
    enable = mkEnableOption "Video and screen functionality";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bazecor
    ];
    users.users.${config.${namespace}.user.name} = {
      extraGroups = ["dialout"]; # bazecor needs this to access the serial port
    };
  };
}
