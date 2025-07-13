{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./gandicloud.nix
    ./wakapi.nix
  ];

  users.users.joonas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlZjgPGkod3ZHstX7jZJnShM6J4JdlIBL+O1P3tvRKU"
  ];

  lumi = {
    suites.cli.enable = true;
    suites.system-utilities.enable = true;

    cli.zellij.enableNushellIntegration = false;

    # This is slow on the server, so disable it.
    cli.nushell.showFastfetchOnStartup = false;

    services = {
      mealie.enable = true;
      donetick.enable = true;
      wallos.enable = true;

      ntfy.enable = true;

    };
  };

  lumi.services.ssh.enable = true;

  lumi-private = {
    services.borgbackup = {
      enable = true;
      repositories = [
        {
          path = "ssh://zxb95s79@zxb95s79.repo.borgbase.com/./repo";
          label = "nixos-server on BorgBase";
        }
      ];
    };
  };


  networking.hostName = "nixos-server"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [80 443];
  # Enable networking
  networking.networkmanager.enable = true;
}
