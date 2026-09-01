{den, ...}: {
  den.aspects.nixos-laptop = {
    includes = with den.aspects; [
      gui
      ssh
      printing

      opencode
      school

      gpu.nvidia
      # backup
    ];
    nixos = {
      imports = [
        # Include the results of the hardware scan.
        ./_hardware.nix
      ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Enable networking
      networking.networkmanager.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "fi";
        variant = "";
      };

      console.keyMap = "fi";

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    };

    homeManager.home.stateVersion = "23.11";
  };
}
