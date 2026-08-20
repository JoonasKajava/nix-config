{den, ...}: {
  den.aspects.nixos-home-server = {
    backup.repositories = [
      {
        path = "ssh://piabn1gh@piabn1gh.repo.borgbase.com/./repo";
        label = "nixos-desktop on BorgBase";
      }
    ];
    includes = with den.aspects; [
      base
      ssh
      ssh-server
      cli

      karakeep
      mealie
      donetick
      wallos
      opencloud

      ntfy
      immich
      homepage-dashboard
      changedetection-io
      uptime-kuma
      home-assistant
      wakapi-server
      forgejo
      couchdb

      # Monitor disk health and send notifications.
      smartd

      paperless

      docker
      tailscale

      den.batteries.hostname
      backup
    ];

    nixos = {config, ...}: {
      services = {
        tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
        thermald.enable = true;
      };

      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
      };

      networking = {
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
    };

    homeManager.home.stateVersion = "25.11";
  };
}
