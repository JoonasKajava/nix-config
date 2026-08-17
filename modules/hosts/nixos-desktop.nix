{den, ...}: {
  # host aspect

  flake.den = den;

  den.aspects.nixos-desktop = {
    # # host NixOS configuration
    # nixos = {pkgs, ...}: {
    #   environment.systemPackages = [pkgs.hello];
    # };
    #
    # # host provides default home environment for its users
    # provides.to-users.homeManager = {pkgs, ...}: {
    #   home.packages = [pkgs.vim];
    # };

    includes = with den.aspects; [
      den.batteries.host-aspects
      gui
      ssh

      maccel
      gpu.amd

      bazecor
      printing

      jetbrains
      jetbrains.rider
      jetbrains.datagrip

      docker
      obs-studio
      parsec

      winboat
      school
      work
      zed


    ];

    nixos = {
      pkgs,
      modulesPath,
      lib,
      config,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/328f1220-8df1-4014-a29f-8a7a6adaef76";
        fsType = "ext4";
      };

      swapDevices = [];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      hardware.enableRedistributableFirmware = true;

      system.stateVersion = "23.11";

      boot = {
        initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage"];
        initrd.kernelModules = [];
        kernelModules = ["kvm-amd"];
        extraModulePackages = [];
        loader = {
          # Bootloader.
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # # try fix windows clock issue
      # time.hardwareClockInLocalTime = true;

      networking = {
        networkmanager = {
          # Enable networking
          enable = true;
          plugins = [
            pkgs.networkmanager-openvpn
          ];
        };
      };

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };

    homeManager.home.stateVersion = "23.11";

    # backup.repositories.nixos-desktop = {
    #   path = "ssh://piabn1gh@piabn1gh.repo.borgbase.com/./repo";
    #   label = "nixos-desktop on BorgBase";
    # };
  };
}
