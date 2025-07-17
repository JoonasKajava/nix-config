{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.apps.gimp;
in {
  options.${namespace}.apps.gimp = {
    enable = mkEnableOption "Whether to install the gimp";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp3-with-plugins
    ];
  };
}
