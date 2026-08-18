{
  den.aspects.plymouth = let
    theme = "connect";
  in {
    nixos = {pkgs, ...}: {
      boot = {
        plymouth = {
          enable = true;
          inherit theme;
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
  };
}
