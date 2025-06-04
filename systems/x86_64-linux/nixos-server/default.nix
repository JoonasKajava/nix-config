{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./gandicloud.nix];

  users.users.joonas.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAlZjgPGkod3ZHstX7jZJnShM6J4JdlIBL+O1P3tvRKU"
  ];

  lumi = {
    suites.cli.enable = true;

    services = {
      docker = {
        enable = true;
        wallos = true;
      };
    };
  };

  lumi.services.ssh.enable = true;

  networking.hostName = "nixos-server"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
}
