{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.nvidia;
in {
  options.mystuff.nvidia = {
    enable = mkEnableOption "Nvidia";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        egl-wayland
      ];

      sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
    # boot.blacklistedKernelModules = ["nouveau"];

    services.xserver.videoDrivers = ["nvidia"];

    boot.kernelModules = ["nvidia-uvm" "nvidia_modeset" "nvidia" "nvidia_drm"];

    # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11_beta];

    # boot.initrd.kernelModules = ["nvidia"];

    boot.kernelParams = [
      "nvidia_drm.fbdev=1"
      "module_blacklist=i915"
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
