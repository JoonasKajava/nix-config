{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.office.obsidian;
in {
  options.mystuff.office.obsidian = {
    enable = mkEnableOption "Obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
