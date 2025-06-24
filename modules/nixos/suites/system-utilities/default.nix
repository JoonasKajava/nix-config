{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.suites.system-utilities;
in {
  options.${namespace}.suites.system-utilities = {
    enable = mkEnableOption "Whether to enable system utilities suite.";
  };

  config = mkIf cfg.enable {
    lumi.services.systemd-notifications.enable = true;
  };
}
