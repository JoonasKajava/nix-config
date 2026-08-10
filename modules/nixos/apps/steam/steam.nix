{den, ...}: {
  den.aspects.steam = {
    nixos = {pkgs, ...}: {
      environment.sessionVariables = {
        PROTON_FSR4_UPGRADE = "1";
        PROTON_XESS_UPGRADE = "1";
        PROTON_ENABLE_WAYLAND = "1";
      };

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = false;

          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };

        gamemode.enable = true;
      };
    };

    includes = [
      den.aspects.gui
    ];
  };
}
