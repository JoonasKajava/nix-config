{
  den.aspects.parsec.homeManager = {pkgs, ...}: let
    # 6.6.2025 still happens
    parsec-fix-desktop-item = pkgs.makeDesktopItem {
      name = "parsec-fix";
      exec = "rm /home/joonas/.parsec/window.json";
      desktopName = "Fix Parsec by deleting window.json";
    };
  in {
    environment.systemPackages = with pkgs; [
      parsec-bin
      #parsec-fix-desktop-item
    ];
  };
}
