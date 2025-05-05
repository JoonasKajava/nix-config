{
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./hardware.nix];
  boot = {
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  lumi = {
    # TODO: remove once latest is >= 6.15
    system.kernelPackages = pkgs.linuxPackages_testing;

    suites.cli.enable = true;

    apps = {
      brave.enable = true;
      kdeconnect.enable = true;
      obsidian.enable = true;
      _1password.enable = true;
      gimp.enable = true;
      kdenlive.enable = true;
      discord.enable = true;
      minecraft.enable = true;
      steam.enable = true;
      lutris.enable = true;
      kitty.enable = true;
      easyeffects.enable = true;
      vlc.enable = true;
      parsec.enable = true;
      onlyoffice.enable = true;
      heroic.enable = true;

      jetbrains = {
        enable = false; #TODO:enable once build is fixed
        ide = {
          rider = true;
          rust-rover = true;
        };
      };
    };

    cli.mangohud.enable = true;

    desktop = {
      kde.enable = true;
      hyprland.enable = false;
    };

    hardware = {
      gpu.amd.enable = true;
      audio.enable = true;
      keyboards.bazecor.enable = true;
      video = {
        enable = true;
        monitors = rec {
          DP-2 = {
            width = 2560;
            height = 1440;
            refreshRate = 165;
            #scale = 1440.0 / 1080.0;
            # Currently this scale works with workspaces in the hyprpanel.
            scale = 1.25;
            #scale = 1.15;
            position = "1920x0";
          };
          HDMI-A-2 = {
            width = 1920;
            height = 1080;
            refreshRate = 60;
            scale = 1;
            position = "${toString (HDMI-A-1.width + (DP-2.width / DP-2.scale))}x0";
          };
          HDMI-A-1 = {
            width = 1920;
            height = 1080;
            refreshRate = 60;
            scale = 1;
            position = "0x0"; # use nwg-displays to figure these out
          };
        };
      };
    };

    services = {
      printing.enable = true;
      docker.enable = false; # Disable docker for now.
    };
  };

  lumi-private = {
    services.borgbackup.enable = true;
  };

  networking.hostName = "nixos-desktop"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    wowup-cf
    slack
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
