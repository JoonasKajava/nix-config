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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

    firefox.enable = false;
    brave.enable = true;
    gnome.enable = false;
    hyprland.enable = false;
    kde.enable = true;
    nvidia.enable = true;
    office.obsidian.enable = true;
    onepassword.enable = true;
    studio.enable = true;
    discord.enable = true;
    virtualization.enable = true;
    printing.enable = true;
    work.enable = true;
    yazi.enable = true;

    gaming = {
      warhammer.enable = false;
      lutris.enable = true;
      wow.enable = true;

      steam.enable = true;
      heroic.enable = true;
    };

    terminal = {
      kitty.enable = true;
      tmux.enable = true;
    };

    audio = {
      easyeffects.enable = true;
    };

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

  environment.systemPackages = with pkgs; [
    bazecor
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
