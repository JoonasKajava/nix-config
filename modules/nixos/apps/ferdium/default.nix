{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
with lib; let
  cfg = config.${namespace}.apps.ferdium;
in {
  options.${namespace}.apps.ferdium = {
    enable = mkEnableOption "Whether to install ferdium";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ferdium
    ];
  };
}
