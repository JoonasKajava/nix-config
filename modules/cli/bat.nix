{
  den.aspects.cli.nixos = {
    lib,
    config,
    ...
  }: {
    programs.bat = {
      enable = true;
    };

    environment.variables = {
      SYSTEMD_COLORS = "false";
      SYSTEMD_PAGERSECURE = "true";
      SYSTEMD_PAGER = "${lib.getExe config.programs.bat.package} -l syslog -p";
    };
  };
}
