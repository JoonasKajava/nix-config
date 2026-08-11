{
  den.aspects.desktop.kde = {
    nixos.programs.kdeconnect = {
      enable = true;
    };

    homeManager.services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
