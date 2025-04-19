{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.hardware.gpu.amd;
in {
  options.${namespace}.hardware.gpu.amd = {
    enable = mkEnableOption "amd gpu related stuff";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.noretry=0"
      "panic=30"
    ];

    environment.variables = {
      KWIN_DRM_NO_DIRECT_SCANOUT = "1"; # TODO ONLY TO TEST GPU GRASH
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
