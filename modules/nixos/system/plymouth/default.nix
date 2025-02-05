{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  theme = "connect";
  cfg = config.${namespace}.system.plymouth;
in {
  options.${namespace}.system.plymouth = {
    enable = mkEnableOption "Whether to install Plymouth and configure it as the boot splash screen.";
  };

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
