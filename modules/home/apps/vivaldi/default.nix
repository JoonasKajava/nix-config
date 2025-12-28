{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.apps.vivaldi;
in {
  options.${namespace}.apps.vivaldi = {
    enable = mkEnableOption "Whether to install the Vivaldi browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vivaldi
      kdePackages.plasma-browser-integration
    ];

    home.file.".config/vivaldi/custom.css".source =
      config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/modules/home/apps/vivaldi/custom.css";
  };
}
