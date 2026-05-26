{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.themes.stylix;
in {
  options.${namespace}.themes.stylix = {
    enable = mkEnableOption "Whether to enable the stylix.";
  };
  config = mkIf cfg.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
  };
}
