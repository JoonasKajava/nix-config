{
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [./gandicloud.nix];

  users.users.joonas.openssh.authorizedKeys.keyFiles = [
    config.sops.secrets."ssh/nixos-server/public".path
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
