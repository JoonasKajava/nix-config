{
  den.aspects.printing = {
    nixos = {pkgs, ...}: {
      services = {
        printing = {
          enable = true;
          drivers = with pkgs; [
            hplip
            cups-filters
            cups-browsed
          ];
        };
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    };
  };
}
