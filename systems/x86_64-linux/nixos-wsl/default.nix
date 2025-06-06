# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];
  wsl = {
    enable = true;
    interop = {
      includePath = true;
    };
    wslConf = {
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
    };
    defaultUser = config.lumi.user.name;
  };

  lumi = {
    suites.cli.enable = true;

    # Do not open zellij automatically because it does not work well with jetbrains IDEs
    cli.zellij.enableNushellIntegration = false;
  };

  environment.systemPackages = with pkgs; [
    lazygit
  ];

  networking.hostName = "nixos-wsl";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
