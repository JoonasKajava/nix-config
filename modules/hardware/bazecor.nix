{
  den.aspects.bazecor = {
    provides.to-users.user.extraGroups = ["dialout"];
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        bazecor
      ];
    };
  };
}
