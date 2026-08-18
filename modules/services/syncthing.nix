{
  den.aspects.syncthing.homeManager = {
    services.syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;
      tray = {
        # enable = osConfig.${namespace}.hardware.video.displayBackend != "terminal";
        enable = true;
      };
    };
  };
}
