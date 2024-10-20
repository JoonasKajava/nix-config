{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.office.obsidian;
in {
  options.office.obsidian = {
    enable = mkEnableOption "Obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
