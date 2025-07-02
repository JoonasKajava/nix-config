{
  lib,
  namespace,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.joonas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlZjgPGkod3ZHstX7jZJnShM6J4JdlIBL+O1P3tvRKU"
  ];

  services.ddns-updater = {
    enable = true;
    environment = {
      TZ = "Europe/Berlin";
      CONFIG_FILEPATH = config.sops.secrets.home-server-ddns-config.path;
    };
  };

  lumi = {
    suites.cli.enable = true;

    cli.zellij.enableNushellIntegration = false;

    # services = {
    #   karakeep.enable = true;
    #   docker = {
    #     enable = true;
    #     wallos = true;
    #   };
    # };
  };

  lumi.services.ssh.enable = true;

  lumi-private = {
    services.borgbackup = {
      enable = true;
      repositories = [
        {
          path = "ssh://o5fkvkv8@o5fkvkv8.repo.borgbase.com/./repo";
          label = "nixos-home-server on BorgBase";
        }
      ];
    };
  };

  networking = {
    hostName = "nixos-home-server"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
