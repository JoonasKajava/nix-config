{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.bottles;
in {
  options.${namespace}.apps.bottles = {
    enable = mkEnableOption "Whether to install bottles";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
