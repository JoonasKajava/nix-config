{
  den.aspects.auto-system-rebuild.nixos = {
    system.autoUpgrade = {
      enable = true;
      flake = "github:JoonasKajava/nix-config";
      allowReboot = true;
    };
  };
}
