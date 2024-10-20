{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.office;
in {
  options.mystuff.office = {
    enable = mkEnableOption "Office";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
