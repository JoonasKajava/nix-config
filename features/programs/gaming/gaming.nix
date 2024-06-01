{
  pkgs,
  lib,
  user,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  mystuff.mangohud.enable = true;
}
