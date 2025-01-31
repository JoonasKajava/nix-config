{
  config,
  lib,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.minecraft;
in {
  options.mystuff.minecraft = {
    enable = mkEnableOption "Enable minecraft";
    enableServer = mkEnableOption "Enable minecraft server";
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        prismlauncher
      ];
    };
  };
}
