{
  den.aspects.easyeffects.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      easyeffects
    ];
  };
}
