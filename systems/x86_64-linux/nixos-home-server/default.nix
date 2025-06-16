{
  lib,
  namespace,
  config,
  ...
}: {
  imports = [
    ./temp.nix
  ];

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

    services = {
      karakeep.enable = true;
      docker = {
        enable = true;
        wallos = true;
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

  services.caddy = {
    enable = true;
    virtualHosts = {
      "wallos.joonaskajava.com".extraConfig = ''
        reverse_proxy http://localhost:8282
      '';
    };
  };
  networking = {
    hostName = "nixos-home-server"; # Define your hostname.
    firewall.allowedTCPPorts = [80 443];
    # Enable networking
    networkmanager.enable = true;
  };
}
