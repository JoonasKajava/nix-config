{
  lib,
  den,
  ...
}: {
  den.default.nixos.system.stateVersion = lib.mkDefault "25.11";
  den.default.homeManager.home.stateVersion = lib.mkDefault "25.11";

  # enable hm by default
  den.schema.user.classes = lib.mkDefault ["homeManager"];

  # User TODO: REMOVE THIS
  den.aspects.tux.nixos = {
    boot.loader.grub.enable = false;
    fileSystems."/".device = "/dev/fake";
    fileSystems."/".fsType = "auto";
  };
}
