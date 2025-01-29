# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  desktop,
  user,
  ...
}: {
  imports = [
    ../../modules/default.nix

    # ../../desktops/${desktop}.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./backups.nix
  ];
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

  networking.hostName = "nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  mystuff = {
    os = {
      plymouth.enable = false; # Otherwise good, but it shows on the wrong screen
    };

    brave.enable = true;
    kde = {
      enable = true;
      plasma-manager.enable = true;
    };

    devices = {
      kdeconnect.enable = true;
    };

    nvidia.enable = true;
    office.obsidian.enable = true;
    onepassword.enable = true;
    studio.enable = false; # this causes build fail https://github.com/NixOS/nixpkgs/issues/369212
    discord.enable = true;
    virtualization.enable = false; # This causes build fail https://github.com/NixOS/nixpkgs/issues/359723
    printing.enable = true;
    work.enable = true;
    yazi.enable = true;

    bazecor.enable = true;

    minecraft.enable = true;
    gaming = {
      warhammer.enable = false;
      lutris.enable = true;
      wow.enable = true;

      steam.enable = true;
      heroic.enable = false; # This does not work for now
    };

    terminal = {
      kitty.enable = true;
      tmux.enable = true;
    };

    audio = {
      easyeffects.enable = true;
    };

    vlc.enable = true;

    editors = {
      jetbrains = {
        enable = true;
        ide = {
          rider = true;
          rust-rover = true;
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Semi temporary packages
  environment.systemPackages = with pkgs; [
    gparted
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
