{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.apps.jetbrains;
in {
  options.${namespace}.apps.jetbrains = {
    enable = lib.mkEnableOption "Jetbrains";
  };

  config = lib.mkIf cfg.enable {
    home.file.".ideavimrc".source =
      config.lib.file.mkOutOfStoreSymlink
      "/etc/nixos/modules/home/apps/jetbrains/.ideavimrc";
  };
}
