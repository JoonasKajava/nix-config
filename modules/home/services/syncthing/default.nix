{
  lib,
  config,
  namespace,
  osConfig ? {
    ${namespace}.hardware.video.displayBackend = "wayland";
  },
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.services.syncthing;
in {
  options.${namespace}.services.syncthing = {
    enable = mkEnableOption "Whether to enable syncthing.";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;
      tray = {
        enable = osConfig.${namespace}.hardware.video.displayBackend != "terminal";
      };
    };
  };
}
