{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.brave;
in {
  options.mystuff.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}
