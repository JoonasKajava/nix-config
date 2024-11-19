{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
with lib; let
  cfg = config.mystuff.work;
in {
  options.mystuff.work = {
    enable = mkEnableOption "work related stuff";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
      # pkgs-stable.parsec-bin
      microsoft-edge
    ];
  };
}
