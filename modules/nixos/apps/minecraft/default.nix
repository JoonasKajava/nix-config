{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.minecraft;
in {
  options.${namespace}.apps.minecraft = {enable = mkEnableOption "minecraft";};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}
