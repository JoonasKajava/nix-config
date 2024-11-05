{
  config,
  lib,
  pkgs,
  nixos-stable,
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
      nixos-stable.parsec-bin
      microsoft-edge
    ];
  };
}
