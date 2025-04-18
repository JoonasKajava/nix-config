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
      "panic=30"
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
