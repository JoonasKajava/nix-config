{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.services.ssh;
in {
  options.${namespace}.services.ssh = {
    enable = mkEnableOption "Whether to enable ssh services";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
    services.resolved.enable = true;
  };
}
