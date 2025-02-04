{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mystuff.os.plymouth;
  theme = "connect";
in {
  options.mystuff.os.plymouth = {
    enable = mkEnableOption "plymouth";
  };

  #
  # Migrated to Snowfall
  #
  config = mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = theme;
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [theme];
          })
        ];
      };

      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log-priority=3"
        "rd.udev.log-priority=3"
      ];
    };
  };
}
