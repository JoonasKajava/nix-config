{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.mangohud;
in {
  options.${namespace}.cli.mangohud = {enable = mkEnableOption "mangohud";};

  config = mkIf cfg.enable {
    #
    # Add mangohud %command% to steam launch options

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
