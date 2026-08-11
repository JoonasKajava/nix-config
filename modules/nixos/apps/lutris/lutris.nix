{
  den.aspects.gaming.lutris.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lutris
      umu-launcher
      protonup-qt
    ];
  };
}
