{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.work.knowit;
in {
  options.mystuff.work.knowit = {
    enable = mkEnableOption "Enable software required by knowit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
      parsec-bin
      microsoft-edge
    ];
  };
}
