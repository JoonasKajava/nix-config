{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.plasma-manager;
in {
  options.mystuff.plasma-manager = {
    enable = mkEnableOption "plasma manager";
  };

  config =
    mkIf cfg.enable {
    };
}
