{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.networking.remote.freerdp;
in {
  options.mystuff.networking.remote.freerdp = {
    enable = mkEnableOption "freeRDP";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      freerdp
    ];
  };
}
