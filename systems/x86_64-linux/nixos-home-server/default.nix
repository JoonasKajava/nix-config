{
  lib,
  namespace,
  config,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlZjgPGkod3ZHstX7jZJnShM6J4JdlIBL+O1P3tvRKU"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/I9fBvav2dg4zYvScZ/+ipDEs68WylJAEYTYwwRWDk"
  ];

  users.users.joonas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlZjgPGkod3ZHstX7jZJnShM6J4JdlIBL+O1P3tvRKU"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/I9fBvav2dg4zYvScZ/+ipDEs68WylJAEYTYwwRWDk"
  ];

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=ignore
      HandleSuspendKey=ignore
    '';
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = ["button.lid_init_state=open"];
  };

  lumi = {
    suites.cli.enable = true;
    suites.system-utilities.enable = true;

    cli.zellij.enableNushellIntegration = false;

    # This is slow on the server, so disable it.
    cli.nushell.showFastfetchOnStartup = false;

    services = {
      karakeep.enable = false;
      mealie.enable = false;
      donetick.enable = false;
      wallos.enable = false;

      ntfy.enable = false;

      tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      };
    };
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
