{
  den.aspects.bazecor = {
    user.extraGroups = ["dialout"];
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        bazecor
      ];
    };
  };
}
