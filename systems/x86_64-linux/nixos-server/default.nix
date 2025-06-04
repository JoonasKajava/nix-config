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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
