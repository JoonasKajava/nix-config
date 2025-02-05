{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.heroic;
in {
  options.${namespace}.apps.heroic = {enable = mkEnableOption "heroic";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
    ];
  };
}
