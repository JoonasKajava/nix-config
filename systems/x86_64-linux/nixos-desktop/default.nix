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
    kernelParams = [
      "video=DP-1:2560x1440@165"
      "video=DP-2:1920x1080@144"
      "video=HDMI-A-1:1920x1080@60"
    ];
  };

  lumi = {
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
      jetbrains = {
        enable = true;
        ide = {
          rider = true;
          rust-rover = true;
        };
      };
    };
    desktop = {
      kde.enable = true;
    };

    hardware.gpu.nvidia.enable = true;
    hardware.audio.enable = true;
    hardware.keyboards.bazecor.enable = true;

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
