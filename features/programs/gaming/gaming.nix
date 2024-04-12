{ pkgs, lib, user, ... }:

{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

}
