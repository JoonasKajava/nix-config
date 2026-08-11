{
  den.aspects.bottles.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
