{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf mkDefault;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.system;
in {
  options.${namespace}.system = {
    kernelPackages = mkOpt types.raw pkgs.linuxPackages_latest "What kernelPackages to use";
  };

  config = {
    boot.kernelPackages = mkDefault cfg.kernelPackages;
  };
}
