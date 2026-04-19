{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.hardware.maccel;
in {
  options.${namespace}.hardware.maccel = {
    enable = mkEnableOption "Enable maccel for NixOS";
  };

  config = mkIf cfg.enable {
    hardware.maccel = {
      enable = true;
      enableCli = true;
      parameters = {
        mode = "linear";
        sensMultiplier = 1.0;
        acceleration = 0.1;
        offset = 10.0;
        outputCap = 2.0;
      };
    };
  };
}
