{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.discord;
in {
  options.mystuff.discord = {
    enable = mkEnableOption "Enable Discrod";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
