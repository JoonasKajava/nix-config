{
  den.aspects.discord.homeManager = {pkgs, ...}: {
    programs.discord = {
      enable = true;
      settings = {
        IS_MAXIMIZED = true;
        IS_MINIMIZED = false;
        enableHardwareAcceleration = true;
        asyncVideoInputDeviceInit = false;
      };
    };
  };
}
