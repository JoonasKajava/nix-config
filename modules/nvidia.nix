{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mystuff.nvidia;
in {
  options.mystuff.nvidia = {
    enable = mkEnableOption "Nvidia";
  };

  config = mkIf cfg.enable {
    # boot.blacklistedKernelModules = ["nouveau"];

    services.xserver.videoDrivers = ["nvidia"];

    # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11_beta];

    # boot.initrd.kernelModules = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
    };

    hardware.graphics = {
      enable = true;
    };
  };
}
