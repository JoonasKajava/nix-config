{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkIf;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.nix;
in {
  options.${namespace}.nix = {
  };

  config = {
    nix = {
      settings = {experimental-features = ["nix-command flakes"];};
      settings.auto-optimise-store = true;

      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };
  };
}
