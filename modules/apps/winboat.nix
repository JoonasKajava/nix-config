{
  # den.aspects.joonas.user = {
  #   extraGroups = ["docker"];
  # };

  den.aspects.winboat.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      winboat
    ];

    # TODO: Require podman or docker
  };
}
