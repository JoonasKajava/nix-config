let
  openPorts = false;
in {
  den.aspects.gaming.minecraft = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        prismlauncher
        ftb-app
      ];
    };

    nixos = {lib, ...}: {
      networking.firewall = lib.mkIf openPorts {
        allowedTCPPorts = [25565];
        allowedUDPPorts = [25565];
      };
    };
  };
}
