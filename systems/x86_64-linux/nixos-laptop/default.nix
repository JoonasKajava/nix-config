{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];

  config = {
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos-laptop"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "fi";
      variant = "";
    };

    console.keyMap = "fi";
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    lumi = {
      suites.cli.enable = true;

      apps = {
        brave.enable = true;
        kdeconnect.enable = true;
        obsidian.enable = true;
        _1password.enable = true;
        gimp.enable = true;
        discord.enable = true;
        steam.enable = true;
        kitty.enable = true;
        vlc.enable = true;
        jetbrains = {
          enable = false;
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

      services.printing.enable = true;
      services.ssh.enable = true;
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
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
  };
}
