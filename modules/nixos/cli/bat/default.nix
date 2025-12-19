{
  lib,
  config,
  namespace,
  ...
}:
with lib; let
  cfg = config.${namespace}.cli.bat;
in {
  options.${namespace}.cli.bat = {enable = mkEnableOption "bat";};

  config = mkIf cfg.enable {
    environment.variables = {
      SYSTEMD_COLORS = "false";
      SYSTEMD_PAGERSECURE = "true";
      SYSTEMD_PAGER = "${lib.getExe config.programs.bat.package} -l syslog -p";
    };

    programs.bat = {
      enable = true;
    };
  };
}
